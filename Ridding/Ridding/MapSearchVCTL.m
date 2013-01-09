//
//  MapSearchVCTL.m
//  Ridding
//
//  Created by zys on 12-12-26.
//
//

#import "MapSearchVCTL.h"

@interface MapSearchVCTL ()

@end

@implementation MapSearchVCTL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil placemarks:(NSArray*)placemarks
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _placemarks=[[NSMutableArray alloc]init];
    [_placemarks addObjectsFromArray:placemarks];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.barView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
  [self.barView.leftButton setTitle:@"返回" forState:UIControlStateHighlighted];
  [self.barView.titleLabel setText:@"位置搜索"];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_placemarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapSearchVCTL"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:@"MapSearchVCTL"];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
  CLPlacemark *mark=[_placemarks objectAtIndex:indexPath.row];
  cell.textLabel.text=mark.name;
  cell.textLabel.font=[UIFont systemFontOfSize:13];
  cell.textLabel.textColor=COLOR_GRAY;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(self.delegate){
    CLPlacemark *mark=[_placemarks objectAtIndex:indexPath.row];
    [self.delegate didSelectPlaceMarks:self placemark:mark];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  [self.navigationController popViewControllerAnimated:YES];
}

@end
