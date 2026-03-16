#!/bin/bash
# verify.sh - compile KingOfTheEtherThrone v0.3.0 and compare to on-chain runtime
# Compiler: soljson-v0.2.0-nightly.2016.1.20+commit.67c855c5, optimizer OFF

set -e

COMPILER="soljson-v0.2.0-nightly.2016.1.20+commit.67c855c5.js"
ONCHAIN="onchain-runtime.hex"

if [ ! -f "$COMPILER" ]; then
    echo "Downloading compiler..."
    curl -L "https://binaries.soliditylang.org/bin/$COMPILER" -o "$COMPILER"
fi

echo "Compiling with $COMPILER (optimizer OFF)..."
node - <<'EOF'
var Module = require('./soljson-v0.2.0-nightly.2016.1.20+commit.67c855c5.js');
var fs = require('fs');
var src = fs.readFileSync('KingOfTheEtherThrone.sol', 'utf8');
var compile = Module.cwrap('compileJSON', 'string', ['string', 'number']);
var output = JSON.parse(compile(src, 0)); // 0 = optimizer OFF
if (output.errors) output.errors.forEach(function(e) { console.error(e); });
var runtime = output.contracts['KingOfTheEtherThrone'].runtimeBytecode;
fs.writeFileSync('compiled-runtime.hex', runtime);
console.log('Compiled: ' + (runtime.length/2) + ' bytes');
EOF

ONCHAIN_HEX=$(cat "$ONCHAIN")
COMPILED_HEX=$(cat compiled-runtime.hex)

if [ "$ONCHAIN_HEX" = "$COMPILED_HEX" ]; then
    echo "EXACT MATCH - bytecode is identical"
else
    echo "MISMATCH"
    python3 -c "
a='$ONCHAIN_HEX'; b='$COMPILED_HEX'
for i in range(min(len(a),len(b))):
    if a[i]!=b[i]:
        print(f'First diff at hex char {i} (byte {i//2}, 0x{i//2:04x})')
        break
if len(a)!=len(b): print(f'Length: onchain={len(a)//2} compiled={len(b)//2}')
"
fi
