package com.open.util;

import redis.clients.jedis.Jedis;

public class RedisJava {

    public static void main(String[] args) {
        Jedis jedis = new Jedis("localhost");
        System.out.println(jedis.ping());
        String key = "key1";
        String value = "value1";
        jedis.set(key, value);
        System.out.println(jedis.get(key));
    }

}
