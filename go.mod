module github.com/wheelergeo/g-otter

go 1.20

require (
	github.com/cloudwego/kitex v0.8.0
	github.com/spf13/cobra v1.8.0
	github.com/wheelergeo/g-otter-gateway v0.0.1
)

require (
	github.com/apache/thrift v0.13.0 // indirect
	github.com/bytedance/go-tagexpr/v2 v2.9.2 // indirect
	github.com/bytedance/gopkg v0.0.0-20230728082804-614d0af6619b // indirect
	github.com/bytedance/sonic v1.10.2 // indirect
	github.com/chenzhuoyu/base64x v0.0.0-20230717121745-296ad89f973d // indirect
	github.com/chenzhuoyu/iasm v0.9.1 // indirect
	github.com/cloudwego/hertz v0.7.3 // indirect
	github.com/cloudwego/netpoll v0.5.1 // indirect
	github.com/fsnotify/fsnotify v1.5.4 // indirect
	github.com/golang/protobuf v1.5.2 // indirect
	github.com/henrylee2cn/ameda v1.4.10 // indirect
	github.com/henrylee2cn/goutil v0.0.0-20210127050712-89660552f6f8 // indirect
	github.com/inconshreveable/mousetrap v1.1.0 // indirect
	github.com/klauspost/cpuid/v2 v2.2.4 // indirect
	github.com/nyaruka/phonenumbers v1.0.55 // indirect
	github.com/spf13/pflag v1.0.5 // indirect
	github.com/tidwall/gjson v1.14.4 // indirect
	github.com/tidwall/match v1.1.1 // indirect
	github.com/tidwall/pretty v1.2.0 // indirect
	github.com/twitchyliquid64/golang-asm v0.15.1 // indirect
	golang.org/x/arch v0.2.0 // indirect
	golang.org/x/sys v0.0.0-20220817070843-5a390386f1f2 // indirect
	google.golang.org/protobuf v1.28.1 // indirect
)

replace github.com/wheelergeo/g-otter/gateway => ./gateway

replace github.com/wheelergeo/g-otter/otter_gen => ./otter_gen
