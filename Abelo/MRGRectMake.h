//
//  MRGRectMake.h
//

#ifndef MRGUiCommon_MRGRect_h
#define MRGUiCommon_MRGRect_h

#include <CoreGraphics/CGGeometry.h>


/**
	Sets X value of frame origin.
 */
CG_INLINE CGRect MRGRectMakeSetX(CGFloat x, CGRect frame);

/**
	Sets Y value of frame origin.
 */
CG_INLINE CGRect MRGRectMakeSetY(CGFloat y, CGRect frame);

/**
	Sets X and Y values of frame origin.
 */
CG_INLINE CGRect MRGRectMakeSetXY(CGFloat x, CGFloat y, CGRect frame);

/**
	Changes X value of frame origin by delta amount.
 */
CG_INLINE CGRect MRGRectMakeDeltaX(CGFloat deltaX, CGRect frame);

/**
	Changes Y value of frame origin by delta amount.
 */
CG_INLINE CGRect MRGRectMakeDeltaY(CGFloat deltaY, CGRect frame);

/**
	Changes X and Y values of frame origin by delta amounts.
 */
CG_INLINE CGRect MRGRectMakeDeltaXY(CGFloat deltaX, CGFloat deltaY, CGRect frame);

/**
 Changes X and Y values of frame origin by delta amounts, and sets the size.
 */
CG_INLINE CGRect MRGRectMakeDeltaXYSize(CGFloat deltaX, CGFloat deltaY, CGSize size, CGRect frame);

/**
	Sets width value of frame size.
 */
CG_INLINE CGRect MRGRectMakeSetWidth(CGFloat width, CGRect frame);

/**
	Sets height value of frame size.
 */
CG_INLINE CGRect MRGRectMakeSetHeight(CGFloat height, CGRect frame);

/**
	Sets width and height values of frame size.
 */
CG_INLINE CGRect MRGRectMakeSetWidthAndHeight(CGFloat width, CGFloat height, CGRect frame);

/**
	Changes width value of frame size by delta amount.
 */
CG_INLINE CGRect MRGRectMakeDeltaWidth(CGFloat deltaWidth, CGRect frame);

/**
	Changes height value of frame size by delta amount.
 */
CG_INLINE CGRect MRGRectMakeDeltaHeight(CGFloat deltaHeight, CGRect frame);

/**
	Changes width and height values of frame size by delta amounts.
 */
CG_INLINE CGRect MRGRectMakeDeltaWidthAndHeight(CGFloat deltaWidth, CGFloat deltaHeight, CGRect frame);

/**
	Changes width and height values of frame size by delta amounts, and sets the origin.
 */
CG_INLINE CGRect MRGRectMakeDeltaWidthAndHeightOrigin(CGFloat deltaWidth, CGFloat deltaHeight, CGPoint origin, CGRect frame);

/**
	Sets frame origin.
 */
CG_INLINE CGRect MRGRectMakeSetOrigin(CGPoint origin, CGRect frame);

/**
	Sets frame size.
 */
CG_INLINE CGRect MRGRectMakeSetSize(CGSize size, CGRect frame);



/*** Definitions of inline functions. ***/

CG_INLINE CGRect MRGRectMakeSetX(CGFloat x, CGRect frame) {
	return CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
}

CG_INLINE CGRect MRGRectMakeSetY(CGFloat y, CGRect frame) {
	return CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
}

CG_INLINE CGRect MRGRectMakeSetXY(CGFloat x, CGFloat y, CGRect frame) {
	return CGRectMake(x, y, frame.size.width, frame.size.height);
}

CG_INLINE CGRect MRGRectMakeDeltaX(CGFloat deltaX, CGRect frame) {
	return CGRectMake(frame.origin.x + deltaX, frame.origin.y, frame.size.width, frame.size.height);
}

CG_INLINE CGRect MRGRectMakeDeltaY(CGFloat deltaY, CGRect frame) {
	return CGRectMake(frame.origin.x, frame.origin.y + deltaY, frame.size.width, frame.size.height);
}

CG_INLINE CGRect MRGRectMakeDeltaXY(CGFloat deltaX, CGFloat deltaY, CGRect frame) {
	return CGRectMake(frame.origin.x + deltaX, frame.origin.y + deltaY, frame.size.width, frame.size.height);
}

CG_INLINE CGRect MRGRectMakeDeltaXYSize(CGFloat deltaX, CGFloat deltaY, CGSize size, CGRect frame) {
	return CGRectMake(frame.origin.x + deltaX, frame.origin.y + deltaY, size.width, size.height);
}

CG_INLINE CGRect MRGRectMakeSetWidth(CGFloat width, CGRect frame) {
	return CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
}

CG_INLINE CGRect MRGRectMakeSetHeight(CGFloat height, CGRect frame) {
	return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
}

CG_INLINE CGRect MRGRectMakeSetWidthAndHeight(CGFloat width, CGFloat height, CGRect frame) {
	return CGRectMake(frame.origin.x, frame.origin.y, width, height);
}

CG_INLINE CGRect MRGRectMakeDeltaWidth(CGFloat deltaWidth, CGRect frame) {
	return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + deltaWidth, frame.size.height);
}

CG_INLINE CGRect MRGRectMakeDeltaHeight(CGFloat deltaHeight, CGRect frame) {
	return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + deltaHeight);
}

CG_INLINE CGRect MRGRectMakeDeltaWidthAndHeight(CGFloat deltaWidth, CGFloat deltaHeight, CGRect frame) {
	return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + deltaWidth, frame.size.height + deltaHeight);
}

CG_INLINE CGRect MRGRectMakeDeltaWidthAndHeightOrigin(CGFloat deltaWidth, CGFloat deltaHeight, CGPoint origin, CGRect frame) {
	return CGRectMake(origin.x, origin.y, frame.size.width + deltaWidth, frame.size.height + deltaHeight);
}

CG_INLINE CGRect MRGRectMakeSetOrigin(CGPoint origin, CGRect frame) {
	return CGRectMake(origin.x, origin.y, frame.size.width, frame.size.height);
}

CG_INLINE CGRect MRGRectMakeSetSize(CGSize size, CGRect frame) {
	return CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
}

CG_INLINE CGRect MRGRectMakeSetOriginSize(CGFloat x, CGFloat y, CGSize size) {
    return CGRectMake(x, y, size.width, size.height);
}

#endif
