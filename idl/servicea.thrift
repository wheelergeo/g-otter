namespace go servicea

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

service MyService2{
    string Hello(1:required MyReq req)
}
