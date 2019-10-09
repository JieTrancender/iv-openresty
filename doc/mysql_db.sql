create table `notes`
(
    `id` int(11) primary key auto_increment comment '主键id',
    `content` varchar(512) not null default '' comment '笔记内容'
) comment = '记录表';