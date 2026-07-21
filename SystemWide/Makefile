ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:16.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LSpoofSystem

LSpoofSystem_FILES = \
	../Source/dylib_init.m \
	../Source/LSHooking.m \
	../Source/LocationSpoofer.m \
	../Source/LSLocationState.m \
	../Source/LSLocationBridge.m \
	../Source/LSSystemWideBridge.m \
	../Source/LSSpoofProvider.m \
	../Source/LSLocationHookAdapter.m \
	../Source/RouteSimulator.m \
	../Source/VehicleDynamics.m \
	../Source/BookmarksManager.m \
	../Source/OverlayWindow.m \
	../Source/MapPickerViewController.m \
	../Source/MapPickerViewController+Route.m \
	../Source/MapPickerViewController+Bookmarks.m \
	../Source/PersistenceManager.m

LSpoofSystem_CFLAGS = -fobjc-arc -Wall -Wextra -I../Source
LSpoofSystem_FRAMEWORKS = Foundation UIKit CoreLocation MapKit

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"
