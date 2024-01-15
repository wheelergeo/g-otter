namespace go user

struct BaseReq {
    1: i64 PageNum
    2: i64 PageSize
    3: bool Order
}

struct BaseResp {
    1: i64 Code
    2: string Message
}

struct LoginReq{
    1:required string PhoneNum
    2:required string Password
}

struct LoginResp{
    1: string Token
    2: BaseResp Status
}

service UserService{
    LoginResp Login(1:required LoginReq req)
}
