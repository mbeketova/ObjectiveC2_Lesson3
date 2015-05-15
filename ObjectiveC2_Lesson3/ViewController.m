//
//  ViewController.m
//  ObjectiveC2_Lesson3
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"

@interface ViewController () {
    BOOL isCurrentLocation;
}

//--------------------------------------------------------------------------------------------------------------------------

/*ДЗ : реализовать TableView поверх MapView.
По Лог Пресс добавлять адрес точки касания в массив. При нажатии на кнопку перезагружать таблицу и добовлять аннотации на карту.
При нажатии на табличную ячейку должен происходить фокус на конкретную аннотацию*/


//Примечание: Реализовала TableView,  MapView. По Лог Пресс добавляется адрес точки касания в массив и устанавливается маркер.
//Добавила две кнопки. При нажатии на кнопку: Добавить - добавляются все отмеченные маркером аллокации в массив.
//При нажатии на кнопку: Очистить - очищаются все аллокации (массив не стала очищать, хотя строчку с одновременным очищением массива
//при нажатии на кнопку закомментировала).
//При нажатии на табличную ячейку происходит фокус на конкретную аннотацию. Кроме того, в таблице можно удалить адрес.

//--------------------------------------------------------------------------------------------------------------------------

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) NSMutableArray* arrayAdress;

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender;
- (IBAction)button_Cleaning:(id)sender;
- (IBAction)button_AddTable:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *viewTableView;

@end

@implementation ViewController

//--------------------------------------------------------------------------------------------------------------------------

- (void) firstStart {
    //метод, который срабатывает один раз при первом запуске, если версия IOS = 8, или выше.
    NSString * ver = [[UIDevice currentDevice]systemVersion];
    
    if ([ver intValue] >=8) {
        [self.locationManager requestAlwaysAuthorization];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstStart"];
    }
    
}
//--------------------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    isCurrentLocation = NO;

    
    self.arrayAdress = [[NSMutableArray alloc]init];
    
    self.mapView.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;

    //срабатывает только при первом запуске:
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstStart"];
    
    if (!isFirstStart) {
        [self firstStart];
    }
    
   
    // если массив пустой, то таблицу делаем прозрачной:
    self.viewTableView.tag = 500;
    if (self.arrayAdress.count == 0) {
        self.viewTableView.alpha = 0;
    }


    
}



//--------------------------------------------------------------------------------------------------------------------------
#pragma mark - MKMapViewDelegate


- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
//    метод, который можно использовать, пока загружается карта - оставила в записи для истории

    
}



- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    //метод, который работает после того, как полностью загружена карта
    
    if (fullyRendered) {
        [self.locationManager startUpdatingLocation];
    }
    
}



- (void) setupMapView: (CLLocationCoordinate2D) coord {
    
    //увеличение карты с анимацией до масштаба карты 500х500 метров
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
    [self.mapView setRegion:region animated:YES];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //устанавливаем маркер при длительном нажатии на карту
    if (![annotation isKindOfClass:MKUserLocation.class]) {
        
        MKAnnotationView*annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
        annView.canShowCallout = NO;
        annView.image = [UIImage imageNamed:@"marker_apartments.png"];
        
        [annView addSubview:[self getCalloutView:annotation.title]]; //вызываем метод, который подписывает адрес над маркером
        
        return annView;

    }
    

    return nil;
}



- (UIView*) getCalloutView: (NSString*) title { // метод, который подписывает данные над маркером
    
    //создаем вью для вывода адреса:
    UIView * callView = [[UIView alloc]initWithFrame:CGRectMake(-60, -50, 150, 50)];
    callView.backgroundColor = [UIColor yellowColor];
    callView.layer.borderWidth = 1.0;
    callView.layer.cornerRadius = 7.0;
    
    
    callView.tag = 1000;
    callView.alpha = 0; //делаем прозрачной вью с адресом, чтобы не высвечивалось на карте при установке маркеров
    
    //создаем лейбл для вывода адреса
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 150, 50)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping; // перенос по словам
    label.textAlignment = NSTextAlignmentCenter; //выравнивание по центру
    label.textColor = [UIColor blackColor];
    label.text = title;
    label.font = [UIFont fontWithName: @"Arial" size: 10.0];
    
    [callView addSubview:label];
    
    return callView;
   
    
}

//--------------------------------------------------------------------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    //данный метод делает видимой вью с адресом при нажатии на маркер
    if (![view.annotation isKindOfClass:MKUserLocation.class]) {
        for (UIView * subView in view.subviews) {
            if (subView.tag == 1000) {
                subView.alpha = 1;
            }
        }
    }
    
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    //данный метод делает невидимой вью с адресом при нажатии на другой элемент
    for (UIView * subView in view.subviews) {
        if (subView.tag == 1000) {
            subView.alpha = 0;
        }
    }

}

//--------------------------------------------------------------------------------------------------------------------------


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    //метод будет срабатывать, когда позиция пользователя изменилась
    
    
    if (!isCurrentLocation) { //использовать тогда, когда надо зафиксировать местоположение пользователя (можно так же подключить еще NSTimer -  чтобы фиксация действовала какое-то время)
        isCurrentLocation = YES;
        [self setupMapView:newLocation.coordinate];
    }
    
}

//--------------------------------------------------------------------------------------------------------------------------


- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender {
    // метод, который срабатывает при длительном нажатии на карту
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        //получаем координаты точки нажатия:
        CLLocationCoordinate2D coordScreenPoint = [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];
        CLGeocoder * geocoder = [[CLGeocoder alloc]init];
        
        //по координатам точки касания получаем адрес:
        CLLocation * tapLocation = [[CLLocation alloc] initWithLatitude:coordScreenPoint.latitude longitude:coordScreenPoint.longitude];
        [geocoder reverseGeocodeLocation:tapLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark * place = [placemarks objectAtIndex:0];
            
          
        //записываем адрес с индексом в NSString
            NSString * adressString = [[NSString alloc] initWithFormat:@"%@\n%@\nИндекс - %@", [place.addressDictionary valueForKey:@"City"], [place.addressDictionary valueForKey:@"Street"], [place.addressDictionary valueForKey:@"ZIP"]];
        
            MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
            annotation.title = adressString;
            annotation.coordinate = coordScreenPoint;
           

            [self.mapView addAnnotation:annotation]; //добавляем на карту аннотацию
            
            
            //добавляем данные в массив для заполнения таблицы:
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          [place.addressDictionary valueForKey:@"City"], @"City",
                                          [place.addressDictionary valueForKey:@"Street"], @"Street",
                                          [place.addressDictionary valueForKey:@"ZIP"], @"ZIP",
                                          tapLocation, @"location", nil];
            
            
            [self.arrayAdress addObject: dict];

            
        }];
    }
 
    
}

//--------------------------------------------------------------------------------------------------------------------------

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayAdress.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * simpleTaibleIndefir = @"Cell";
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:simpleTaibleIndefir];
    
    cell.label_City.text = [[self.arrayAdress objectAtIndex:indexPath.row]objectForKey:@"City"];
    cell.label_Street.text = [[self.arrayAdress objectAtIndex:indexPath.row]objectForKey:@"Street"];
    cell.label_ZIP.text = [[self.arrayAdress objectAtIndex:indexPath.row]objectForKey:@"ZIP"];
   
    

    
    return cell;
    

    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //данная процедура позволяет редактировать таблицу
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //этот метод будет срабатывать, если стиль редактирования: удалить
    if (editingStyle ==  UITableViewCellEditingStyleDelete) {
        UILocalNotification * notif = [self.arrayAdress objectAtIndex:indexPath.row];
        [self.arrayAdress removeObjectAtIndex:indexPath.row];
        [[UIApplication sharedApplication] cancelLocalNotification:notif];
        [self reloadTableView];
    }
}

//--------------------------------------------------------------------------------------------------------------------------

//метод, который перезагружает таблицу:
- (void) reloadTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];});
}

//--------------------------------------------------------------------------------------------------------------------------

- (void) removeAllAnnotations { //метод, который убирает аннотации с карты
    id userAnnotation = self.mapView.userLocation;
    NSMutableArray*annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [annotations removeObject:userAnnotation];
    [self.mapView removeAnnotations:annotations];

}


//--------------------------------------------------------------------------------------------------------------------------

//дейсвия кнопок:

- (IBAction)button_Cleaning:(id)sender {
   [self removeAllAnnotations]; // по нажатию на кнопку убираем аннотации с карты
    [self.arrayAdress removeAllObjects]; // очищаем массив
    [self reloadTableView]; // перезагружаем таблицу
    self.viewTableView.alpha = 0; // прячем таблицу

}

- (IBAction)button_AddTable:(id)sender {
    
    [self reloadTableView]; // по нажатию на кнопку - перезагружаем таблицу
    self.viewTableView.alpha = 1;
    [self.view bringSubviewToFront:self.viewTableView];
}
//--------------------------------------------------------------------------------------------------------------------------

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //по индексу ячейки находим координаты в массиве self.arrayAdress и устанавливаем данные координаты по центру карты
    NSDictionary * dict = [self.arrayAdress objectAtIndex:indexPath.row];
    CLLocation * newLocation = [[CLLocation alloc] init];
    newLocation = [dict objectForKey:@"location"];
    [self setupMapView:newLocation.coordinate];


}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
