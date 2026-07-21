ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:16.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LSpoof

LSpoof_FILES = \
	Source/TweakInit.m \
	Source/LSHooking.m \
	Source/LocationSpoofer.m \
	Source/LSLocationState.m \
	Source/LSLocationBridge.m \
	Source/LSSystemWideBridge.m \
	Source/LSSpoofProvider.m \
	Source/LSLocationHookAdapter.m \
	Source/RouteSimulator.m \
	Source/VehicleDynamics.m \
	Source/BookmarksManager.m \
	Source/OverlayWindow.m \
	Source/MapPickerViewController.m \
	Source/MapPickerViewController+Route.m \
	Source/MapPickerViewController+Bookmarks.m \
	Source/PersistenceManager.m

LSpoof_CFLAGS = -fobjc-arc -Wall -Wextra -ISource
LSpoof_FRAMEWORKS = Foundation UIKit CoreLocation MapKit

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"
