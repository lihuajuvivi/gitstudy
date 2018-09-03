-- 创建一个临时内存表
DROP TABLE IF EXISTS `vote_record_memory`;
CREATE TABLE `vote_record_memory` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` VARCHAR(20) NOT NULL DEFAULT '',
    `vote_num` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `group_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `status` TINYINT(2) UNSIGNED NOT NULL DEFAULT '1',
    `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `index_user_id` (`user_id`) USING HASH
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `vote_record`;
CREATE TABLE `vote_record` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` VARCHAR(20) NOT NULL DEFAULT '' COMMENT '用户Id',
    `vote_num` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '投票数',
    `group_id` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '用户组id 0-未激活用户 1-普通用户 2-vip用户 3-管理员用户',
    `status` TINYINT(2) UNSIGNED NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-已删除',
    `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `index_user_id` (`user_id`) USING HASH COMMENT '用户ID哈希索引'
) ENGINE=INNODB DEFAULT CHARSET=utf8 COMMENT='投票记录表';


DELIMITER // -- 修改MySQL delimiter：'//'
-- 创建插入数据的存储过程
DROP PROCEDURE IF EXISTS `add_vote_record_memory` //
CREATE PROCEDURE `add_vote_record_memory`(IN n INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE vote_num INT DEFAULT 0;
    DECLARE group_id INT DEFAULT 0;
    DECLARE STATUS TINYINT DEFAULT 1;
    WHILE i < n DO
        SET vote_num = FLOOR(1 + RAND() * 10000);
        SET group_id = FLOOR(0 + RAND()*3);
        SET STATUS = FLOOR(1 + RAND()*2);
        INSERT INTO `vote_record_memory` VALUES (NULL, 'aaaaa', vote_num, group_id, STATUS, NOW());
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;  -- 改回默认的 MySQL delimiter：';'
#调用存储过程
CALL add_vote_record_memory(11)

#将临时内存表中的数据存储到指定表中
INSERT INTO `vote_record` SELECT * FROM `vote_record_memory`

