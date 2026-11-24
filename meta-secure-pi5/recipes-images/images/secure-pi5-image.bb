SUMMARY = "Hardened minimal image for Raspberry Pi 5"
LICENSE = "MIT"

require recipes-core/images/core-image-minimal.bb

IMAGE_INSTALL:append = " openssh"
