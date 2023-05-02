<!-- Code generated by gomarkdoc. DO NOT EDIT -->

# utils

```go
import "command-line-arguments"
```

## Index

- [Constants](#constants)
- [Variables](#variables)
- [func ChecksumAddressString(address string) string](#func-checksumaddressstring)
- [func EnsureDir(dir string)](#func-ensuredir)
- [func EtherToWei(eth *big.Float) *big.Int](#func-ethertowei)
- [func EtherToWeiFloatToUint64(eth float64) uint64](#func-ethertoweifloattouint64)
- [func HexStringArrayToBytesArray(strArray []string) [][]byte](#func-hexstringarraytobytesarray)
- [func LogErrorWhileRetrying(msg string, err error, retrying *bool, logger *zap.Logger)](#func-logerrorwhileretrying)
- [func Min(a, b int) int](#func-min)
- [func RecoverSigAddress(sigHex string, msg []byte) (address string, err error)](#func-recoversigaddress)
- [func SplitAddressList(addressList string, separator string) []common.Address](#func-splitaddresslist)
- [func VerifySig(from string, sigHex string, msg []byte) (bool, string, error)](#func-verifysig)

## Constants

RetryAttempts is how many attempts are made to reconnect to an Ethereum client before failing.

```go
const RetryAttempts = 60 * 60
```

RetryDelay is the delay between reconnects to an Ethereum client.

```go
const RetryDelay = 1 * time.Second
```

## Variables

```go
var ServiceDelayType = retry.DelayType(func(n uint, err error, config *retry.Config) time.Duration {
    return retry.FixedDelay(n, err, config)
})
```

```go
var ServiceRetryAttempts = retry.Attempts(RetryAttempts)
```

```go
var ServiceRetryDelay = retry.Delay(RetryDelay)
```

## func [ChecksumAddressString](https://github.com/latticexyz/mud/blob/main/packages/services/pkg/utils/address.go#L24)

```go
func ChecksumAddressString(address string) string
```

## func [EnsureDir](https://github.com/latticexyz/mud/blob/main/packages/services/pkg/utils/io.go#L12)

```go
func EnsureDir(dir string)
```

EnsureDir creates a given dir directory in case it does not already exist.

## func [EtherToWei](https://github.com/latticexyz/mud/blob/main/packages/services/pkg/utils/general.go#L33)

```go
func EtherToWei(eth *big.Float) *big.Int
```

## func [EtherToWeiFloatToUint64](https://github.com/latticexyz/mud/blob/main/packages/services/pkg/utils/general.go#L43)

```go
func EtherToWeiFloatToUint64(eth float64) uint64
```

## func [HexStringArrayToBytesArray](https://github.com/latticexyz/mud/blob/main/packages/services/pkg/utils/general.go#L21)

```go
func HexStringArrayToBytesArray(strArray []string) [][]byte
```

## func [LogErrorWhileRetrying](https://github.com/latticexyz/mud/blob/main/packages/services/pkg/utils/retry.go#L19)

```go
func LogErrorWhileRetrying(msg string, err error, retrying *bool, logger *zap.Logger)
```

LogErrorWhileRetrying is a wrapper for less verbose logging when retrying some actions, for instance, reconnecting to an Ethereum client.

## func [Min](https://github.com/latticexyz/mud/blob/main/packages/services/pkg/utils/general.go#L14)

```go
func Min(a, b int) int
```

## func [RecoverSigAddress](https://github.com/latticexyz/mud/blob/main/packages/services/pkg/utils/signature.go#L11)

```go
func RecoverSigAddress(sigHex string, msg []byte) (address string, err error)
```

## func [SplitAddressList](https://github.com/latticexyz/mud/blob/main/packages/services/pkg/utils/address.go#L11)

```go
func SplitAddressList(addressList string, separator string) []common.Address
```

SplitAddressList splits a list of addresses initially given as a string addressList along with a separator to use to split the string.

## func [VerifySig](https://github.com/latticexyz/mud/blob/main/packages/services/pkg/utils/signature.go#L34)

```go
func VerifySig(from string, sigHex string, msg []byte) (bool, string, error)
```

Generated by [gomarkdoc](https://github.com/princjef/gomarkdoc)