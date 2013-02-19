//
//  MapSearchVCTL.m
//  Ridding
//
//  Created by zys on 12-12-26.
//
//

#import "MapSearchVCTL.h"
#import "MapSearchCell.h"
#import "Utilities.h"
@interface MapSearchVCTL ()

@end

@implementation MapSearchVCTL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil placemarks:(NSArray *)placemarks {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _placemarks = [[NSMutableArray alloc] init];
    [_placemarks addObjectsFromArray:placemarks];
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  [self.barView.titleLabel setText:@"地理位置搜索"];

}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return [_placemarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  MapSearchCell *cell = (MapSearchCell *) [Utilities cellByClassName:@"MapSearchCell" inNib:@"MapSearchCell" forTableView:self.tv];
  CLPlacemark *mark = [_placemarks objectAtIndex:indexPath.row];
  if (cell != nil) {
    [cell initView:mark.name];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  if (self.delegate) {
    CLPlacemark *mark = [_placemarks objectAtIndex:indexPath.row];
    [self.delegate didSelectPlaceMarks:self placemark:mark];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  [self.navigationController popViewControllerAnimated:YES];
}

@end
