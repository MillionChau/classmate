# Xây dựng ứng dụng Quản lí học sinh bằng Flutter, Dart và MongoDB
## Giới thiệu
- Ứng dụng quản lí là một ứng dụng rất thực tế. Trong thời đại và bùng nổ của công nghệ thông tin các sản phẩm quản lí học sinh online là không thể thiếu với nhiều trường. Nó không chỉ quản lí chặt chẽ chính xác mà còn đa năng về vị trí địa lí khi có thể cập nhật mọi lúc mọi nơi và xem thông tin bất cứ khi nào cần thiết mà không cần phải hỏi người khác hay gửi thông báo qua từng lớp. Việc này đã giúp rất nhiều trường tiết kiệm thời gian và xửu lí linh hoạt.
- Flutter là một ngôn ngữ đa nền tảng có thể xây dựng ứng dụng chạy trên nhiều nền tảng khác nhau. Việc chỉ cần build từ một source code mà được nhiều nền tảng đã giúp việc tiết kiệm thời gian cho các developer trong việc phát triển ứng dụng cho nhiều nền tảng khác nhau.
- Dart là một ngôn ngữ bậc cao ra mắt vào năm 2011. Với khả năng hướng đối tượng và linh hoạt dart đã trở thành ngôn ngữ nền tảng của flutter giúp việc xây dựng ứng dụng đa nền tảng trở nên dễ dàng
- MongoDB là một Cơ sở dữ liệu noSQL tuy rất đa dụng nhưng với sản phẩm này không thể phát huy hết thế mạnh của nó. Nhưng vì quen thuộc với nó nhất nên tôi đã sử dụng nó làm CSDL. Nếu có thể phát triển tôi sẽ sử dụng ngôn ngữ SQL để xây dựng vì ứng dụng quả lí với models có sẵn việc phải viết thêm một models để làm cơ sở dữ liệu là không cần thiết. Nhưng thôi. Tôi thích thì tôi dùng nó vậy.
## Mục tiêu
- Một ứng dụng quản lí hơn hết là phải quản lí được học sinh và nhân viên. Trong ứng dụng sẽ xây dựng 3 role chính:
+ Admin: có quyền quản lí Nhân viên cấp dưới, Giáo viên và học sinh, Quản lí liên quan đến thông báo... Nói chung admin to nhất, thích làm gì làm.
+ Giáo viên(Teacher): Giáo viên phụ trách nhập điểm cho sinh viên. Yêu cầu up thông báo và xem lịch giảng dạy
+ Học sinh(Student): Học sinh có thể đọc thông báo, xem điểm và xem thời khoá biểu
- Xây dựng các chức năng cho từng role đã nêu trên
- Kết nối cơ sở dữ liệu để lưu trữ thông tin
- Xây dựng layout phù hợp đẹp mắt trên ứng dụng mobile
- Thực hiện kiểm thử unit test và integration test để kiểm tra ứng dụng
- Nếu có thể sẽ kiểm thử e2e và CI/CD để kiểm thử tự động
## Yêu cầu ứng dụng
- Các chức năng hoạt động bình thường và chính xác trên môi trường máy ảo và mô trường máy thật(Trên môi trường dev)
- Các chức năng CRUD hoạt động đúng
- Thực hiện kiểm thử ít nhất là unit test và integration test
- Tích hợp API để xử lí luồng
- Tích hợp CSDL để lưu trữ thông tin
## Cấu trúc thư mục
- Backend
     + bin/ - Chứa file server.dart
     + lib
        + api/ - chứa các file controllers
        + controllers/ - chứa các file controllers
        + middlewares/ - chứa các file middlewares
        + models/ - chứa các file models
        + services/ chứa file service để kết nối CSDL
    + test/ - Chứa các file kiểm thử
- classmate_app
    + lib/
        + models/ - chứa models của ứng dụng
        + routes/ chứa các file routes
        + screens/ chứa các màn hình chính
        + service/ chứa các dịch vụ ví dụ đăng nhập
        + widget/ chứa các widget sử dụng nhiều trong ứng dụng
        + main.dart file chính front-end của ứng dụng
## Quá trình thực hiện
### Khởi tạo dự án
### Xây dựng backend
### Xây dựng front-end
### Tiến hành kiểm thử
## Tự đánh giá