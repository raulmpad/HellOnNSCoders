#import "EventTests.h"
#import "Session.h"

@implementation EventTests

Event *instance;

- (void)setUp
{
  [super setUp];
  instance = [[Event alloc] init];
}

- (void)tearDown
{
  instance = nil;
  
  [super tearDown];
}

- (void)testCanCreateIntanceOfEvent
{
  STAssertNotNil(instance, @"Cannot create instance of Event");
}

- (void)testHasAnIdentifier
{
  instance.objectId = @"Identifier";
  
  STAssertEquals(instance.objectId, @"Identifier", @"Cannot set an identifier for an event");
}

- (void)testHasATitle
{
  instance.title = @"TestTitle";
  
  STAssertEquals(instance.title, @"TestTitle", @"Cannot set a title for an event");
}

- (void)testHasAStartDate
{
  NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
  
  instance.startDate = [dateFormater dateFromString:@"01/01/2012"];
  
  STAssertEquals(instance.startDate,[dateFormater dateFromString:@"01/01/2012"], @"Cannot set a start date for an event");
}

- (void)testtHasAEndDate
{
  NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
  
  instance.endDate = [dateFormater dateFromString:@"01/01/2012"];
  
  STAssertEquals(instance.endDate,[dateFormater dateFromString:@"01/01/2012"], @"Cannot set a end date for an event");
}

- (void)testHasAHashtag
{
  instance.hashtag = @"#Evento";
  
  STAssertEquals(instance.hashtag, @"#Evento", @"Cannot set a Hashtag for an event");
}

- (void)testHasALocation
{
  Location *location = [[Location alloc] init];
  
  location.address = @"maresme14";
  instance.location = location;
  
  
  STAssertTrue(instance.location == location,  @"Cannot set a location for an event");
}

- (void)testHasCanAddSession
{
  Session *session = [[Session alloc] init];
  
  [instance addSession: session];
  
  STAssertTrue([instance.sessions count] == 1, @"Test", @"Cannot add a session for an event");
}

- (void)testCanMapParserEvent
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd/mm/yyyy"];
    
    NSDate *start_date = [dateFormater dateFromString:@"01/01/2012"];
    NSDate *end_date = [dateFormater dateFromString:@"02/01/2012"];
    
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    [event setObject:@"Test Title" forKey:@"title"];
    [event setObject:end_date forKey:@"endDate"];
    [event setObject:start_date forKey:@"startDate"];
    [event setObject:@"#testhashtag" forKey:@"hashtag"];
    [event save];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    PFObject *eventFromParser = [query getObjectWithId:event.objectId];
    
    Event *mapedEvent = [[Event alloc] init];
    [mapedEvent mapParserObject:eventFromParser];
    
    BOOL assert_entity_mapping = [mapedEvent.title isEqualToString:@"Test Title"]
    && [mapedEvent.startDate isEqualToDate:start_date]
    && [mapedEvent.endDate isEqualToDate:end_date]
    && [mapedEvent.hashtag isEqualToString:@"#testhashtag"];
    
    STAssertTrue(assert_entity_mapping, @"Could not maps events from parse object");
    
    [eventFromParser delete];
}

@end
