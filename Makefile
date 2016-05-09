include theos/makefiles/common.mk

TWEAK_NAME = 5sky
5sky_FILES = ${wildcard src/*.m}
5sky_FILES += ${wildcard src/Sky/*.m}
5sky_FILES += ${wildcard src/AFNetworking/*.m}
5sky_FILES += ${wildcard src/JTSTextView/*.m}
5sky_FILES += ${wildcard src/PAImageView/*.m}
5sky_FILES += ${wildcard src/SVPullToRefresh/*.m}
5sky_FRAMEWORKS = UIKit Foundation CoreFoundation CoreGraphics QuartzCore SystemConfiguration Security
5sky_PRIVATE_FRAMEWORKS = Preferences MobileCoreServices
5sky_LIBRARIES = objcipc
5sky_CFLAGS = -fobjc-arc -Wno-unused-property-ivar --std=c++11 -stdlib=libc++ -fvisibility=hidden

export TARGET = iphone:clang
export ARCHS = armv7 arm64
export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 8.1
#export ADDITIONAL_OBJCFLAGS = -fobjc-arc -fvisibility=hidden

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
