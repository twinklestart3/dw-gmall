#!/bin/bash

db_name=gmall
table_name=$1
db_date=$2
sqoop=/opt/module/sqoop-1.4.6/bin/sqoop


if [[ -n $db_date ]]; then
    do_date=$db_date
else
    do_date=`date -d "-1 day" +%F`
fi



### --null-string '\\n'和--null-non-string '\\n'解决mysql中null值在hive中的表现形式
### 默认为null这4个字符表示的字符串，修改后表示空值
function import_data(){
    table=$1
    sql=$2

    $sqoop import \
    --connect jdbc:mysql://hadoop222:3306/$db_name \
    --username root \
    --password 123456 \
    --target-dir /origin_data/$db_name/db/$table/$do_date \
    --delete-target-dir \
    --query  "$sql and \$CONDITIONS;"  \
    --num-mappers 1 \
    --fields-terminated-by '\t' \
    --null-string '\\n' \
    --null-non-string '\\n'
}

function import_base_category1(){
    import_data "base_category1" "select id,name from base_category1 where 1=1"
}

function import_base_category2(){
    import_data "base_category2" "select id,name,category1_id from base_category2 where 1=1"
}

function import_base_category3(){
    import_data "base_category3" "select id,name,category2_id from base_category3 where 1=1"
}

function import_order_info(){
    import_data "order_info" "select id,total_amount,order_status,user_id,
                            payment_way,out_trade_no,create_time,operate_time
                            from order_info
                            where (date_format(create_time,'%Y-%m-%d')='$do_date'
                            or date_format(operate_time,'%Y-%m-%d')='$do_date')
                            "
}

function import_order_detail(){
    import_data "order_detail" "select
                                  d.id,
                                  order_id,
                                  user_id,
                                  sku_id,
                                  sku_name,
                                  order_price,
                                  sku_num,
                                  o.create_time
                              from order_info o,order_detail d where o.id=d.order_id
                              and date_format(create_time,'%Y-%m-%d')='$do_date'"
}

function import_sku_info(){
    import_data "sku_info" "select id, spu_id, price, sku_name, sku_desc,
                          weight, tm_id,category3_id, create_time
                          from sku_info where 1=1"
}

function import_user_info(){
    import_data "user_info" "select id, name, birthday, gender, email,
                           user_level,create_time from user_info where 1=1"
}

function import_payment_info(){
    import_data "payment_info" "select
                              id,
                              out_trade_no,
                              order_id,
                              user_id,
                              alipay_trade_no,
                              total_amount,
                              subject,
                              payment_type,
                              payment_time
                              from payment_info
                              where date_format(payment_time,'%Y-%m-%d')='$do_date'"
}


case $table_name in
    base_category1)
        import_base_category1
    ;;
    base_category2)
        import_base_category2
    ;;
    base_category3)
        import_base_category3
    ;;
    order_info)
        import_order_info
    ;;
    order_detail)
        import_order_detail
    ;;
    sku_info)
        import_sku_info
    ;;
    user_info)
        import_user_info
    ;;
    payment_info)
        import_payment_info
    ;;
    all)
        import_base_category1
        import_base_category2
        import_base_category3
        import_order_info
        import_order_detail
        import_sku_info
        import_user_info
        import_payment_info
    ;;
esac