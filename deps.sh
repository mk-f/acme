#!/bin/sh
# install various acme things
# libX11-devel libXt-devel libXext-devel fontconfig-devel
#go install 9fans.net/go/acme/acmego@latest
go install golang.org/x/tools/cmd/goimports@latest
GO111MODULE=on go install 9fans.net/acme-lsp/cmd/acme-lsp@latest
GO111MODULE=on go install 9fans.net/acme-lsp/cmd/L@latest
GO111MODULE=on go install 9fans.net/acme-lsp/cmd/acmefocused@latest

