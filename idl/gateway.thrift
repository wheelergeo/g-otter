# namespace跟路由分组挂钩
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

struct UserLoginReq {
    1: required string PhoneNum (api.body="phoneNum", go.tag="vd:\"phone($)\"");
    2: required string Password (api.body="password", go.tag="vd:\"regexp(^(?=.*[a-zA-Z])(?=.*[0-9])[A-Za-z0-9]{8,18}$)\"");
}

struct UserLoginResp {
    1: string Token
    2: BaseResp Status
}

# service 跟服务挂钩
service UserService {
    UserLoginResp UserLogin(1: UserLoginReq request) (api.post="/user/login");
}
