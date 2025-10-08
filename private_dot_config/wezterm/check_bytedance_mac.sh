#!/bin/bash

# Check if this is a ByteDance Mac by looking for supervision profiles

echo "Checking if this is a ByteDance Mac..."

# Method 1: Check for MDM profiles
if profiles show -type enrollment > /dev/null 2>&1; then
    echo "Found MDM enrollment profiles:"
    profiles show -type enrollment | grep -i "bytedance\|字节\|lark\|飞书"
fi

# Method 2: Check installed configuration profiles
echo -e "\nChecking configuration profiles:"
profiles list | grep -i "bytedance\|字节\|lark\|飞书"

# Method 3: Check system information for organization
echo -e "\nChecking system organization info:"
system_profiler SPHardwareDataType | grep -i "organization\|company"

# Method 4: Check for ByteDance specific applications
echo -e "\nChecking for ByteDance applications:"
ls /Applications/ | grep -i "bytedance\|lark\|飞书"

# Method 5: Check network domains
echo -e "\nChecking network configuration:"
scutil --dns | grep -i "bytedance\|feishu\|lark"

# Method 6: Check for corporate certificates
echo -e "\nChecking certificates:"
security find-certificate -a -c "bytedance\|lark\|飞书" /System/Library/Keychains/SystemRootCertificates.keychain 2>/dev/null

# Final judgment
if profiles list | grep -qi "bytedance\|字节\|lark\|飞书" || \
   ls /Applications/ | grep -qi "bytedance\|lark\|飞书" || \
   system_profiler SPHardwareDataType | grep -qi "bytedance\|字节跳动"; then
    echo -e "\n✅ This appears to be a ByteDance managed Mac"
    exit 0
else
    echo -e "\n❌ This does not appear to be a ByteDance managed Mac"
    exit 1
fi