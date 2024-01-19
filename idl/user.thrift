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

struct RpcWebLoginReq{
    1:required string PhoneNum
    2:required string Password
    3:required string Ip
    4:required string Location
    5:required string Browser
    6:required string Os
}

struct RpcWebLoginResp{
    1: BaseResp Status
    2: string Token
}

struct RpcUpdateUserOnlineReq{
	1: required string Token
	2: required string TokenExpiredAt
	3: required string LoginAt
}

struct RpcUpdateUserOnlineResp{
    1: BaseResp Status
}

service UserService{
    RpcWebLoginResp RpcWebLogin(1:required RpcWebLoginReq req)
	RpcUpdateUserOnlineResp RpcUpdateUserOnline(1:required RpcUpdateUserOnlineReq req)
}
