1. Tạo một network mới (nếu chưa có):

Bash
docker network create my-app-network
2. Kết nối container MariaDB vào network này:

Bash
docker network connect my-app-network mariadb-alpine-ncc
3. Kết nối container PHP vào network này:

Bash
docker network connect my-app-network php-alpine-ncc

# test
docker network create db-network

docker network connect db-network mariadb-alpine-ncc

docker network connect db-network php-alpine-ncc

> Bây giờ bạn quay lại Adminer và nhập lại ô Server là: mariadb-alpine-ncc