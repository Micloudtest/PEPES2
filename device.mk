#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Enable virtual A/B OTA
ENABLE_VIRTUAL_AB := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# API
PRODUCT_TARGET_VNDK_VERSION := 30
PRODUCT_SHIPPING_API_LEVEL := 30

# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    otapreopt_script \
    checkpoint_gc

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot@1.1-impl-qti.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctl

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

# Fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    fastbootd

# Init scripts
PRODUCT_PACKAGES += \
    init.recovery.qcom.sh \
    init.recovery.qcom.rc

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/qcom-caf/bootctrl

# Update engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

PRODUCT_PACKAGES += \
    qcom_decrypt \
    qcom_decrypt_fbe

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/commonsys-intf/display

TARGET_RECOVERY_DEVICE_MODULES += libion vendor.display.config@1.0 vendor.display.config@2.0 libdisplayconfig.qti vendor.qti.hardware.vibrator.service vendor.qti.hardware.vibrator.impl libqtivibratoreffect

#Properties
TW_OVERRIDE_SYSTEM_PROPS := \
    "ro.build.fingerprint=ro.system.build.fingerprint;ro.build.version.incremental"

# Vibrator
TW_SUPPORT_INPUT_AIDL_HAPTICS := true

RECOVERY_BINARY_SOURCE_FILES += \
    $(TARGET_OUT_VENDOR_EXECUTABLES)/hw/vendor.qti.hardware.vibrator.service

RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@1.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@2.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/libdisplayconfig.qti.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/vendor.qti.hardware.vibrator.impl.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/libqtivibratoreffect.so
