

# Tạo Jenkins Credential cho xác thực GitHub

Trong bước này, bạn sẽ tạo credential trên Jenkins về thông tin xác thực tài khoản cho GitHub. Credential này sẽ được sử dụng bởi các Job build của Jenkins Pipeline để truy cập và tải về private repository trên GitHub.

Tại màn hình Dashboard của Jenkins, ấn vào menu Manage Jenkins => Chọn mục Manage Credentials => Ấn vào (global) => Ấn Add Credential, màn hình thông tin Credentials xuất hiện để bạn nhập thông tin.

1. `Kind` : Loại credential, chọn Username with password
Username: Nhập vào email của tài khoản GitHub
Password: Nhập vào peronal access token tạo ra ở phần 1
ID: Định danh cho credential, nhập vào jenkins_github_pac
Description: Thông tin mô tả thêm cho credential.
