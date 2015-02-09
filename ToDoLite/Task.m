//
//  Task.m
//  ToDo Lite
//
//  Created by Jens Alfke on 8/22/13.
//
//

#import "Task.h"
#import "List.h"

#define kTaskDocType @"task"
#define kTaskImageName @"image"

@implementation Task

@dynamic checked, list_id;

+ (NSString*) docType {
    return kTaskDocType;
}

- (void)awakeFromInitializer {
    [super awakeFromInitializer];

    // The "type" property identifies what type of document this is.
    // It's used in map functions and by the CBLModelFactory.
    [self setValue: [[self class] docType] ofProperty: @"type"];
}

- (void) setImage: (NSData*)image contentType: (NSString*)contentType {
    [self setAttachmentNamed:kTaskImageName withContentType:contentType content:image];
}

@end
