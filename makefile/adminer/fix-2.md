Việc gộp cả PHP-FPM và Nginx vào cùng một container là một giải pháp khá phổ biến khi bạn muốn tối ưu tài nguyên trên các dòng máy như ThinkPad T420, vì nó giúp giảm số lượng container phải quản lý.

Sử dụng `init: true` kết hợp với một file `entrypoint.sh` riêng là cách làm chuyên nghiệp nhất. Nó giúp giải quyết triệt để vấn đề "zombie process" mà bạn lo lắng.

Dưới đây là cách triển khai sạch sẽ:

### 1. File `entrypoint.sh` (Đặt cùng thư mục với Dockerfile)
File này đóng vai trò là "quản gia". Nó dọn dẹp nhà cửa xong rồi mới mời các dịch vụ vào ở.

```bash
#!/bin/sh
set -e

# 1. Khởi tạo các thư mục cần thiết
mkdir -p /run/php-fpm
mkdir -p /run/nginx
mkdir -p /var/log/nginx

# 2. Đảm bảo user/group tồn tại (đề phòng image chưa có)
addgroup -S www-data 2>/dev/null || true
adduser -D -S -G www-data www-data 2>/dev/null || true

# 3. Phân quyền cho các thư mục run và log
chown -R www-data:www-data /run/php-fpm
chown -R www-data:www-data /run/nginx
chown -R www-data:www-data /var/log/nginx

# 4. Chạy PHP-FPM ở chế độ chạy ngầm (daemon)
# Lưu ý: Ở đây ta KHÔNG dùng -F vì cần nhường foreground cho Nginx
php-fpm84

# 5. Chạy Nginx ở foreground (đây là tiến trình giữ container sống)
# Dùng 'exec' để Nginx nhận được tín hiệu stop từ Docker
echo "Starting Nginx..."
exec nginx -g "daemon off;"
```

### 2. File `docker-compose.yml`
Tại đây bạn kích hoạt `init: true`. Lúc này, Docker sẽ chèn một chương trình cực nhỏ làm **PID 1** để quản lý cả `entrypoint.sh` và các con của nó.

```yaml
services:
  web-app:
    image: adminer-alpine-ncc
    init: true  # <--- Rất quan trọng để dọn dẹp zombie từ php-fpm và nginx
    volumes:
      - ./entrypoint.sh:/entrypoint.sh
      - ./conf/nginx.conf:/etc/nginx/nginx.conf
      - ./conf/www.conf:/etc/php84/php-fpm.d/www.conf
    entrypoint: ["/bin/sh", "/entrypoint.sh"]
```

---

### Tại sao cách này lại giải quyết được vấn đề của bạn?

1.  **Cơ chế PID:**
    * **PID 1:** Là `tini` (do `init: true` tạo ra). Nó là "người lớn" trong nhà.
    * **PID 2:** Là `entrypoint.sh`.
    * **Các PID con:** Nginx và PHP-FPM.
    

2.  **Dọn dẹp Zombie:** Khi PHP-FPM chạy ngầm, nó có thể sinh ra các tiến trình con ngắn hạn. Nếu chúng trở thành zombie, `tini` (PID 1) sẽ tự động nhận nuôi và dọn dẹp chúng ngay lập tức. Bạn không bao giờ phải lo đầy Process Table.

3.  **Tắt lịch sự (Graceful Shutdown):** Khi bạn `docker stop`, `tini` sẽ nhận được tín hiệu và chuyển tiếp (forward) nó xuống cho Nginx và `entrypoint.sh`. Nhờ có `exec nginx`, Nginx sẽ nhận được tín hiệu trực tiếp và đóng các kết nối đang dang dở trước khi thoát.

### Lưu ý quan trọng khi dùng Alpine:
* Đừng quên cấp quyền thực thi cho file script ở máy thật: `chmod +x entrypoint.sh`.
* Vì bạn chạy chung, hãy chắc chắn Nginx trong `nginx.conf` trỏ đúng vào file socket mà PHP-FPM tạo ra: `fastcgi_pass unix:/run/php-fpm/php-fpm.sock;`.

Cách này giúp file `docker-compose.yml` của bạn nhìn rất "sang", chỉ còn một dòng gọi script, mọi logic phức tạp đã được giấu vào file `.sh` rồi! Bạn có muốn tôi giúp viết luôn cái `nginx.conf` tối ưu cho socket này không?

# entrypoint.sh
# Dọn dẹp tàn dư cũ trước khi khởi động
rm -f /run/php-fpm/php-fpm.sock

# Sau đó mới chạy PHP-FPM
php-fpm84

healthcheck:
  test: ["CMD", "sh", "-c", "ls /run/php-fpm/php-fpm.sock"]
  interval: 10s
  timeout: 5s
  retries: 3

exec mariadbd --user=mysql --console