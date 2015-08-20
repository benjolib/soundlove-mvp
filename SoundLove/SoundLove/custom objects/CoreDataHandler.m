//
//  CoreDataHandler.m
//  SoundLove
//
//  Created by Sztanyi Szabolcs on 23/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

#import "CoreDataHandler.h"
#import "CDConcert.h"
#import "CDConcertLocation.h"
#import "CDConcertImage.h"
#import "CDFriend.h"
#import "ConcertModel.h"
#import "FriendObject.h"

@interface CoreDataHandler ()
@property (readwrite, strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *masterManagedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSDateFormatter *sectionDateFormatter;
@end

@implementation CoreDataHandler

+ (instancetype)sharedHandler
{
    static CoreDataHandler *sharedHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHandler = [[self alloc] init];
    });
    return sharedHandler;
}

- (NSDateFormatter *)sectionDateFormatter {
    if (!_sectionDateFormatter) {
        _sectionDateFormatter = [[NSDateFormatter alloc] init];
        _sectionDateFormatter.dateFormat = @"MMM YYYY"; // twitter date format
    }
    return _sectionDateFormatter;
}

- (NSInteger)numberOfSavedConcerts
{
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:@"CDConcert" predicate:nil sortDescriptor:nil];
    NSError *error = nil;
    NSUInteger fetchedCount = [self.masterManagedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error fetching recordings: %@", error.localizedDescription);
    }
    return fetchedCount;
}

/// Return YES, if it is already exists in Core Data, otherwise save it
- (BOOL)addConcertToFavorites:(ConcertModel*)concertModel
{
    CDConcert *concert = [self concertForConcertModel:concertModel];
    if (concert) {
        [self removeConcertObject:concert];
        return YES;
    }

    concert = [NSEntityDescription insertNewObjectForEntityForName:@"CDConcert" inManagedObjectContext:self.mainManagedObjectContext];
    concert.name = concertModel.name;
    concert.concertID = concertModel.concertID;
    concert.place = concertModel.place;
    concert.city = concertModel.city;
    concert.date = concertModel.date;
    concert.price = concertModel.price;

    if (concertModel.image) {
        CDConcertImage *concertImage = [NSEntityDescription insertNewObjectForEntityForName:@"CDConcertImage" inManagedObjectContext:self.mainManagedObjectContext];
        concertImage.image = UIImageJPEGRepresentation(concertModel.image, 1.0);
        [concert setImage:concertImage];
    }

    CDConcertLocation *concertLocation = [NSEntityDescription insertNewObjectForEntityForName:@"CDConcertLocation" inManagedObjectContext:self.mainManagedObjectContext];
    concertLocation.city = concert.location.city;
    concertLocation.country = concert.location.country;
    concertLocation.zip = concert.location.zip;
    concertLocation.formattedAddress = concert.location.formattedAddress;
    concertLocation.rawAddress = concert.location.rawAddress;
    concertLocation.latitude = concert.location.latitude;
    concertLocation.longitude = concert.location.longitude;
    concertLocation.street = concert.location.street;
    concertLocation.house = concert.location.house;

    [concert setLocation:concertLocation];

    if (concertModel.friendsArray.count > 0)
    {
        for (FriendObject *friend in concertModel.friendsArray) {
            CDFriend *friendObject = [NSEntityDescription insertNewObjectForEntityForName:@"CDFriend" inManagedObjectContext:self.mainManagedObjectContext];
            friendObject.name = friend.name;
            friendObject.identifier = friend.userID;
            friendObject.imageURL = friend.imageURL;

            [concert addFriendsObject:friendObject];
        }
    }

    if (!self.sectionDateFormatter) {
        self.sectionDateFormatter = [[NSDateFormatter alloc] init];
        self.sectionDateFormatter.dateFormat = @"MMM - YYYY";
    }

    concert.sectionTitle = [self.sectionDateFormatter stringFromDate:concertModel.date];

    [self saveMainContext];

    return NO;
}

- (NSArray*)allSavedConcerts
{
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:@"CDConcert" predicate:nil sortDescriptor:@[nameSortDescriptor]];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.masterManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error fetching recordings: %@", error.localizedDescription);
    }
    return fetchedObjects;
}

- (CDConcert*)concertForConcertModel:(ConcertModel*)model
{
    return [self fetchConcertWithID:model.concertID];
}

- (BOOL)isConcertSaved:(ConcertModel*)concertModel
{
    CDConcert *concert = [self concertForConcertModel:concertModel];
    if (concert) {
        return YES;
    }
    return NO;
}

- (void)removeConcertObject:(CDConcert*)concert
{
    [self.mainManagedObjectContext deleteObject:concert];
    [self saveMainContext];
}

- (CDConcert*)fetchConcertWithID:(NSString*)concertID
{
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:@"CDConcert" predicate:[NSPredicate predicateWithFormat:@"concertID == %@", concertID] sortDescriptor:nil];
    fetchRequest.includesPropertyValues = NO;
    fetchRequest.includesSubentities = NO;

    NSError *error = nil;
    NSArray *festivals = [self.mainManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (festivals.count > 0) {
        return festivals.firstObject;
    }
    return nil;
}

- (NSFetchRequest*)fetchRequestForEntity:(NSString*)entityName predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.masterManagedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    // Specify how the fetched objects should be sorted
    if (sortDescriptors) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }

    return fetchRequest;
}

- (void)clearDatabase
{
    [_masterManagedObjectContext lock];
    NSArray *stores = self.persistentStoreCoordinator.persistentStores;
    for (NSPersistentStore *store in stores) {
        NSError *error = nil;
        [_persistentStoreCoordinator removePersistentStore:store error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:&error];
        if (error) {
            NSLog(@"Error occured while deleting core data folder, error: %@", error.localizedDescription);
        }
    }
    [_masterManagedObjectContext unlock];
    _managedObjectModel = nil;
    _mainManagedObjectContext = nil;
    _masterManagedObjectContext = nil;
    _persistentStoreCoordinator = nil;

    [self masterManagedObjectContext];
    [self mainManagedObjectContext];
    [self persistentStoreCoordinator];
}

#pragma mark - mainManagedObjectContext setup
- (NSManagedObjectContext *)mainManagedObjectContext
{
    if (_mainManagedObjectContext) {
        return _mainManagedObjectContext;
    }

    _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainManagedObjectContext.parentContext = self.masterManagedObjectContext;
    _mainManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    return _mainManagedObjectContext;
}

- (void)saveMainContext
{
    [self.mainManagedObjectContext performBlock:^{
        NSError *error = nil;
        [self.mainManagedObjectContext save:&error];
        if (error) {
            NSLog(@"Error while saving MAIN CONTEXT: %@", error.localizedDescription);
        }
        [self saveMasterContext];
    }];
}

- (void)saveMasterContext
{
    [self.masterManagedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        [self.masterManagedObjectContext save:&error];
        if (error) {
            NSLog(@"Error occured while saving MASTER CONTEXT: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - private methods
/**
 *  Lazy getter to create the managed context
 */
- (NSManagedObjectContext *)masterManagedObjectContext
{
    if (_masterManagedObjectContext) {
        return _masterManagedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _masterManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_masterManagedObjectContext setPersistentStoreCoordinator:coordinator];
        _masterManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    return _masterManagedObjectContext;
}

/**
 *  Lazy getter to create the model
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

/**
 *  Lazy getter to create the persistent coordinator
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self coreDataDirectory] URLByAppendingPathComponent:@"Festivalama.sqlite"];

    // Define the Core Data version migration options
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             NSFileProtectionCompleteUnlessOpen, NSPersistentStoreFileProtectionKey, nil];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        abort();
    }

    return _persistentStoreCoordinator;
}

- (NSURL*)coreDataDirectory
{
    NSString *folderPath;
    BOOL isDir;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] == 1)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        folderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"SoundLove"];

        if (![fileManager fileExistsAtPath:folderPath isDirectory:&isDir])
        {
            NSError *error = nil;
            if (![fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:@{NSFileProtectionKey:NSFileProtectionComplete} error:&error]) {
                NSLog(@"Couldn't create the folder, error: %@", error.localizedDescription);
            }
        }
    }
    return [NSURL fileURLWithPath:folderPath isDirectory:YES];
}

@end
