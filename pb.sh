#!/usr/bin/env bash
protoc --descriptor_set_out=./proto/game.pb  ./proto/game.proto
