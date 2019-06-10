CREATE DATABASE Education;
USE Education;

-- 建表
CREATE TABLE `Manager` (
    `Mno`       CHAR(16) NOT NULL,
    `Mname`     CHAR(20) NOT NULL,
    `Msex`      CHAR(5) NOT NULL,
    `Password`  CHAR(10) NOT NULL,
    -- 约束
    CONSTRAINT `mgr_PK` PRIMARY KEY (`Mno`),
    CONSTRAINT `mgr_sex` CHECK (`Msex` = '男' OR `Msex` = '女')
);

CREATE TABLE `Department` (
    Dept    CHAR(20) PRIMARY KEY
);

CREATE TABLE Student (
    `Sno`       CHAR(16) NOT NULL,
    `Sname`     CHAR(20) NOT NULL,
    `Ssex`      CHAR(5) NOT NULL,
    `Sdept`     CHAR(20) NOT NULL,
    `Password`  CHAR(10) NOT NULL,
    -- 约束
    CONSTRAINT `stu_PK` PRIMARY KEY(`Sno`),
    CONSTRAINT `stu_FK` FOREIGN KEY(`Sdept`) REFERENCES Department(`Dept`),
    CONSTRAINT `stu_sex` CHECK(`Ssex` = '男' OR `Ssex` = '女')
);

CREATE TABLE Teacher (
    `Tno`       CHAR(16) NOT NULL,
    `Tname`     CHAR(20) NOT NULL,
    `Tsex`      CHAR(5) NOT NULL,
    `Tdept`     CHAR(20) NOT NULL,
    `Password`  CHAR(10) NOT NULL,
    -- 约束
    CONSTRAINT `tch_PK` PRIMARY KEY(`Tno`),
    CONSTRAINT `tch_FK` FOREIGN KEY(`Tdept`) REFERENCES Department(`Dept`),
    CONSTRAINT `tch_sex` CHECK(`Tsex` = '男' OR `Tsex` = '女')
);

CREATE TABLE Course (
    `Cno`     CHAR(16) NOT NULL,
    `Cname`   CHAR(20) NOT NULL,
    `Credit`  INTEGER NOT NULL,
    `Cdept`   CHAR(20) NOT NULL, -- 所属院系
    `Tno`     CHAR(16) NOT NULL,
    `Cweek`   CHAR(20) NOT NULL,
    `Cday`    INTEGER NOT NULL,
    `Cap`     INTEGER NOT NULL, -- 容量
    `Addr`    CHAR(20) NOT NULL,
    -- 约束
    CONSTRAINT `cos_PK` PRIMARY KEY(`Cno`),
    CONSTRAINT `cos_FK_dep` FOREIGN KEY(`Cdept`) REFERENCES Department(`Dept`),
    CONSTRAINT `cos_FK_tch` FOREIGN KEY(`Tno`) REFERENCES Teacher(`Tno`)
);

CREATE TABLE SC (
    `Sno`   CHAR(16) NOT NULL,
    `Cno`   CHAR(16) NOT NULL, 
    `Grade` INTEGER,
    `GPA`   DOUBLE,
    -- 约束
    CONSTRAINT `sc_FK_stu` FOREIGN KEY (`Sno`) REFERENCES Student(`Sno`),
    CONSTRAINT `sc_FK_crs` FOREIGN KEY (`Cno`) REFERENCES Course(`Cno`),
    CONSTRAINT `sc_PK` PRIMARY KEY (`Sno`, `Cno`)
);

-- 数据部分
INSERT INTO Manager VALUES ('M00001', 'admin', '男', 'passwd');

INSERT INTO Department VALUES
    ('计算机工程系'),('通信工程系'),('软件工程系'),('信息工程系');
INSERT INTO Student VALUES
    ('201608010506', '邱志豪', '男', '计算机工程系', '163456'),
    ('201608010510', '李辰',   '男', '计算机工程系', '163465'),
    ('201608010519', '陈志伦', '男', '计算机工程系', '163546'),
    ('201608010530', '姚沛沛', '女', '计算机工程系', '163564'),
    ('111111111111', 'test', '女', '计算机工程系', 'test'),
    ('201608060209', '戴凌锋', '男', '计算机工程系', '163645');

INSERT INTO Teacher VALUES
    ('T0x00', 'von Neumann', '男', '计算机工程系', '163456'),
    ('T0x01', 'Hopcroft', '男', '计算机工程系', '163456'),
    ('T0x02', 'Turing', '男', '计算机工程系', '163465'),
    ('T0x03', 'Thompson', '男', '计算机工程系', '163546'),
    ('T0x04', 'Dijkstra', '男', '计算机工程系', '163564'),
    ('T0x05', 'Tim Berners-Lee', '男', '计算机工程系', '163645');

INSERT INTO Course VALUES
    ('CS04023','计算机系统',4,'计算机工程系','T0x00',1,1,80,'贝尔实验室'),
    ('CS05073','人工智能导论',4,'计算机工程系','T0x02',2,2,80,'剑桥大学国王学院'),
    ('CS05075','编译原理',4,'计算机工程系','T0x01',3,3,80,'剑桥大学国王学院'),
    ('CS05074','计算机网络',4,'计算机工程系','T0x05',4,4,80,'牛津大学');
