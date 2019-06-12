package com.open.util;

import redis.clients.jedis.Jedis;
import java.sql.*;
import java.util.*;

public class RedisJava {

    private Connection conn;
    private Jedis jedis;

    public RedisJava() {
        MySQLJava open = new MySQLJava();
        conn = open.getConnection();
        jedis = new Jedis("localhost");
    }

    private String Tno2Tname(String Tno, int expire) {
        String Tname = jedis.get(Tno);
        if (Tname == null) {
            try {
                System.out.println("[info] Get Tname from MySQL");
                // 如果Redis中没有数据，尝试从MySQL中获取
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(String.format("SELECT Tname from Teacher WHERE Tno='%s'", Tno));
                rs.next();
                Tname = rs.getString("Tname");
                jedis.set(Tno, Tname);  // 查询之后就放入缓存
                jedis.expire(Tno, expire);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else System.out.println("[info] Get Tname from Redis");
        return Tname;
    }

    public Set<String> CourseBuf(String Sdept, int expire) {
        Set<String> ans = jedis.smembers(Sdept);
        if (ans.isEmpty()) {    // Get from MySQL
            try {
                ans = new TreeSet<>();
                System.out.println("[info] Get course from MySQL");
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(String.format("SELECT * FROM COURSE WHERE Cdept='%S'", Sdept));
                while (rs.next()) {
                    List<String> buf = new ArrayList<>();
                    buf.add(rs.getString("Cno"));
                    buf.add(rs.getString("Cname"));
                    buf.add(rs.getString("Credit"));
                    buf.add(rs.getString("Cdept"));
                    String Tno = rs.getString("Tno");
                    buf.add(Tno2Tname(Tno, 10 * expire));    // 将Tno直接映射为Tname
                    buf.add(rs.getString("Cweek"));
                    buf.add(rs.getString("Cday"));
                    buf.add(rs.getString("Cap"));
                    buf.add(rs.getString("Addr"));
                    String line = String.join("|", buf);
                    ans.add(line);
                    jedis.sadd(Sdept, line);
                    jedis.expire(Sdept, expire);  // 默认20s的存储时间
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else System.out.println("[info] Get courses from Redis");
        return ans;
    }

    public static void main(String[] argv) {
        RedisJava rj = new RedisJava();
        rj.jedis.flushAll();
//        Scanner sc = new Scanner(System.in);
//        String key = sc.nextLine();
        // 计算机工程系
        int expire = 5;
        Set<String> ans = rj.CourseBuf("计算机工程系", expire);
        for (String item: ans) {
            List<String> seq = Arrays.asList(item.split("\\|"));
            System.out.println(seq);
        }
    }

}
