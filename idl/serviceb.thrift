namespace go serviceb

struct BaseReq{
    1:required string name
}

struct MyReq{
    1:required string input
    2:required BaseReq baseReq
}

service MyService{
    string Hello(1:required MyReq req)
}
