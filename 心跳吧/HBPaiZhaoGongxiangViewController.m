//
//  HBPaiZhaoGongxiangViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/25.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBPaiZhaoGongxiangViewController.h"
#import "GCPlaceholderTextView.h"
#import "HBTool.h"
#import "ZYQAssetPickerController.h"
#import "HBCheckDetailImageViewController.h"
#import "ALBBOSSServiceProtocol.h"
#import "ALBBOSSServiceProvider.h"
#import "OSSBucket.h"
#import "OSSData.h"
#import "HBPlaceSelectViewController.h"
#import "HBCategorySelectViewController.h"
#import "HBSendTimeSelectViewController.h"

@interface HBPaiZhaoGongxiangViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UIView* tfView;//textField 视图
@property (nonatomic, strong)UIView* addPhotoView;//添加照片 视图
@property (nonatomic ,strong)UIView* otherView;//分类 邮费——上传到我的专柜 视图

@property (nonatomic, strong)UITextField* titleTF;//宝贝标题
@property (nonatomic, strong)UIButton* addPhotoBtn;//添加照片 按钮
@property (nonatomic, strong)UIButton* ziJiFuBtn;//送方付 按钮
@property (nonatomic, strong)UIButton* duiFangFuBtn;//收方付 按钮
@property (nonatomic, strong)UIButton* oneKgBtn;//1kg内 按钮
@property (nonatomic, strong)UIButton* otherKgBtn;//其它重量 按钮
@property (nonatomic, strong)GCPlaceholderTextView* detailTV;//宝贝详情
@property (nonatomic, strong)UIButton* sendBtn;

@property (nonatomic, strong)NSMutableArray* imagePathArr;//存放上传照片的路径

@property (nonatomic, strong)UIAlertView* atv;//上传进度提示

@end

@implementation HBPaiZhaoGongxiangViewController

//图片大小
#define WIDTH_PHOTO 65
//每一行的高度
#define LINE_HEIGHT 40
//照片之间间距
#define SPACE_PHOTO (self.view.frame.size.width - WIDTH_PHOTO*4)/5

//label距离左 间距
#define SPACE_X_LABEL 10
//label 宽
#define WIDTH_LABEL 70
//送方付 收方付 1kg内 大于1kg 按钮 宽高
#define WIDTH_SELECTBUTTON 95
#define HEIGHT_SELECTBUTTON 30
//上传至专柜 按钮 宽高
#define WIDTH_SENDBUTTON (self.view.frame.size.width/2)
#define HEIGHT_SENDBUTTON 35

//tfView addPhotoView otherView 高
#define HEIGHT_TFVIEW 40
#define HEIGHT_ADDPHOTOVIEW (WIDTH_PHOTO + SPACE_PHOTO*2)
#define HEIGHT_OTHERVIEW (LINE_HEIGHT*7 + 15*3 + HEIGHT_SENDBUTTON)

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.view.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    
    self.scrollView = [self createScrollViewWithY:NAVIGATIOINBARHEIGHT];
    [self.view addSubview:self.scrollView];
    
    self.tfView = [self createTextFieldViewWithY:0];
    [self.scrollView addSubview:self.tfView];
    
    self.addPhotoView = [self createAddPhotoViewWithY:self.tfView.frame.origin.y + self.tfView.frame.size.height];
    [self.scrollView addSubview:self.addPhotoView];
    
    self.otherView = [self createOtherViewWithY:self.addPhotoView.frame.origin.y + self.addPhotoView.frame.size.height];
    [self.scrollView addSubview:self.otherView];
    
    
    self.imageArr = [NSMutableArray array];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];//键盘即将出现
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];//键盘即将消失
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tap];
}

//
-(void)tapView:(UITapGestureRecognizer* )tapGR {
    [self titleTFAndDetailTVResignFirstResponder];
}

//创建scrollView
-(UIScrollView* )createScrollViewWithY:(CGFloat )origin_y {
    UIScrollView* sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.bounds.size.width, self.view.bounds.size.height - origin_y)];
    return sv;
}

//创建tfView
-(UIView* )createTextFieldViewWithY:(CGFloat )origin_y {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.bounds.size.width, HEIGHT_TFVIEW)];
    vi.backgroundColor = COLOR_WHITE1;
    self.titleTF = [[UITextField alloc]initWithFrame:CGRectMake(SPACE_X_LABEL, (HEIGHT_TFVIEW - 20)/2, vi.frame.size.width - SPACE_X_LABEL*2, 20)];
    self.titleTF.placeholder = @"宝贝叫啥，写个标题";
    self.titleTF.textColor = COLOR_BLACK1;
    self.titleTF.font = FONT_17;
    self.titleTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [vi addSubview:self.titleTF];
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, vi.frame.size.height - 1, vi.frame.size.width, 1)];
    line.image = [UIImage imageNamed:@"line.png"];
    [vi addSubview:line];
    return vi;
}

//创建addPhotoView
-(UIView* )createAddPhotoViewWithY:(CGFloat )origin_y {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.bounds.size.width, HEIGHT_ADDPHOTOVIEW)];
    vi.backgroundColor = COLOR_WHITE1;
    self.addPhotoBtn = [[UIButton alloc]initWithFrame:CGRectMake(SPACE_PHOTO, SPACE_PHOTO, WIDTH_PHOTO, WIDTH_PHOTO)];
    [self.addPhotoBtn setImage:[UIImage imageNamed:@"add_photo.png"] forState:UIControlStateNormal];
    self.addPhotoBtn.hidden = NO;
    [self.addPhotoBtn addTarget:self action:@selector(clickedAddPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    [vi addSubview:self.addPhotoBtn];
    return vi;
}

//创建otherView
-(UIView* )createOtherViewWithY:(CGFloat )origin_y {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.bounds.size.width, HEIGHT_OTHERVIEW)];
    vi.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    UIImageView* line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, vi.frame.size.width, 1)];
    line1.image = [UIImage imageNamed:@"line.png"];
    [vi addSubview:line1];
    
    UIButton* classBtn = [self createCellButtonWithX:0 AndY:0 AndWidth:vi.frame.size.width AndHeight:LINE_HEIGHT AndLabelTitle:@"分类"];
    classBtn.tag = 100;
    [vi insertSubview:classBtn belowSubview:line1];
    self.classLab = [self createLabelWithButton:classBtn];
    [classBtn addSubview:self.classLab];
    
    UIView* postMoneyView = [self createCellViewWithX:0 AndY:classBtn.frame.origin.y + classBtn.frame.size.height AndWidth:self.view.frame.size.width AndHeight:LINE_HEIGHT AndLabelTitle:@"邮费"];
    [vi addSubview:postMoneyView];
    CGFloat space_SelectBtn = (vi.frame.size.width - WIDTH_LABEL - SPACE_X_LABEL - WIDTH_SELECTBUTTON*2)/3;
    self.ziJiFuBtn = [self createSelectButtonWithX:space_SelectBtn + SPACE_X_LABEL + WIDTH_LABEL AndY:(LINE_HEIGHT - HEIGHT_SELECTBUTTON)/2 AndWidth:WIDTH_SELECTBUTTON AndHeight:HEIGHT_SELECTBUTTON AndButtonTitle:@"送方付" AndNotSelectedImageName:@"dot_NotSelected.png" AndSelectedImageName:@"dot_Selected.png" AndState:NO];
    [postMoneyView addSubview:self.ziJiFuBtn];
    self.duiFangFuBtn = [self createSelectButtonWithX:space_SelectBtn*2 + SPACE_X_LABEL + WIDTH_LABEL + WIDTH_SELECTBUTTON AndY:self.ziJiFuBtn.frame.origin.y AndWidth:WIDTH_SELECTBUTTON AndHeight:HEIGHT_SELECTBUTTON AndButtonTitle:@"收方付" AndNotSelectedImageName:@"dot_NotSelected.png" AndSelectedImageName:@"dot_Selected.png" AndState:NO];
    [postMoneyView addSubview:self.duiFangFuBtn];
    
    UIImageView* line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, postMoneyView.frame.origin.y + postMoneyView.frame.size.height - 1, self.view.frame.size.width, 1)];
    line2.image = [UIImage imageNamed:@"line.png"];
    [vi addSubview:line2];
    
    UIView* weightView = [self createCellViewWithX:0 AndY:postMoneyView.frame.origin.y + postMoneyView.frame.size.height AndWidth:self.view.frame.size.width AndHeight:LINE_HEIGHT AndLabelTitle:@"重量"];
    [vi addSubview:weightView];
    self.oneKgBtn = [self createSelectButtonWithX:space_SelectBtn + SPACE_X_LABEL + WIDTH_LABEL AndY:(LINE_HEIGHT - HEIGHT_SELECTBUTTON)/2 AndWidth:WIDTH_SELECTBUTTON AndHeight:HEIGHT_SELECTBUTTON AndButtonTitle:@"1kg内" AndNotSelectedImageName:@"dot_NotSelected.png" AndSelectedImageName:@"dot_Selected.png" AndState:NO];
    [weightView addSubview:self.oneKgBtn];
    self.otherKgBtn = [self createSelectButtonWithX:space_SelectBtn*2 + SPACE_X_LABEL + WIDTH_LABEL + WIDTH_SELECTBUTTON AndY:self.ziJiFuBtn.frame.origin.y AndWidth:WIDTH_SELECTBUTTON AndHeight:HEIGHT_SELECTBUTTON AndButtonTitle:@"大于1kg" AndNotSelectedImageName:@"dot_NotSelected.png" AndSelectedImageName:@"dot_Selected.png" AndState:NO];
    [weightView addSubview:self.otherKgBtn];
    
    UIButton* placeBtn = [self createCellButtonWithX:0 AndY:weightView.frame.origin.y + weightView.frame.size.height + 15 AndWidth:self.view.frame.size.width AndHeight:LINE_HEIGHT AndLabelTitle:@"所在地区"];
    placeBtn.tag = 101;
    [vi addSubview:placeBtn];
    self.placeLab = [self createLabelWithButton:placeBtn];
    [placeBtn addSubview:self.placeLab];
    
    UIButton* sendTimeBtn = [self createCellButtonWithX:0 AndY:placeBtn.frame.origin.y + placeBtn.frame.size.height AndWidth:self.view.frame.size.width AndHeight:LINE_HEIGHT AndLabelTitle:@"送出时间"];
    sendTimeBtn.tag = 102;
    [vi addSubview:sendTimeBtn];
    self.sendTimeLab = [self createLabelWithButton:sendTimeBtn];
    [sendTimeBtn addSubview:self.sendTimeLab];
    
    self.detailTV = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(0, sendTimeBtn.frame.origin.y + sendTimeBtn.frame.size.height + 15, self.view.frame.size.width, LINE_HEIGHT*2)];
    self.detailTV.placeholder = @"宝贝其它描述，故事、评价、品牌、新旧、尺寸等";
    self.detailTV.textColor = COLOR_BLACK1;
    self.detailTV.font = FONT_17;
    [vi addSubview:self.detailTV];
    
    self.sendBtn = [self createSendButtonWithTitle:@"上传到我的专柜"];
    [vi addSubview:self.sendBtn];
    
    return vi;
}

//送方付 收方付 1kg内 大于1kg 按钮
-(UIButton* )createSelectButtonWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height AndButtonTitle:(NSString* )titleString AndNotSelectedImageName:(NSString* )notSelectedString AndSelectedImageName:(NSString* )selectedString AndState:(BOOL )selectedState {
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    btn.titleLabel.font = FONT_17;
    [btn setImage:[UIImage imageNamed:notSelectedString] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedString] forState:UIControlStateSelected];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 60)];
    [btn setTitle:titleString forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_GRAY1 forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_BLUE1 forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clickedSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    btn.selected = selectedState;
    return btn;
}

//邮费 重量 为UIView类型
-(UIView* )createCellViewWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height AndLabelTitle:(NSString* )titleString {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    vi.backgroundColor = COLOR_WHITE1;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_X_LABEL, (frame_height - 20)/2, WIDTH_LABEL, 20)];
    lab.text = titleString;
    lab.textColor = COLOR_BLACK1;
    lab.font = FONT_17;
    [vi addSubview:lab];
    return vi;
}

//分类 所在地区 送出时间 为UIButton类型
-(UIButton* )createCellButtonWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height AndLabelTitle:(NSString* )titleString {
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    btn.backgroundColor = COLOR_WHITE1;
    btn.enabled = YES;
    [btn addTarget:self action:@selector(clickedCellButton:) forControlEvents:UIControlEventTouchUpInside];

    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_X_LABEL, (frame_height - 20)/2, WIDTH_LABEL, 20)];
    lab.text = titleString;
    lab.textColor = COLOR_BLACK1;
    lab.font = FONT_17;
    [btn addSubview:lab];
    
    UIImageView* jianTou = [[UIImageView alloc]initWithFrame:CGRectMake(frame_width - SPACE_X_LABEL - 16, (frame_height - 16)/2, 16, 16)];
    jianTou.image = [UIImage imageNamed:@"jianTou.png"];
    [btn addSubview:jianTou];
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame_height - 1, frame_width, 1)];
    line.image = [UIImage imageNamed:@"line.png"];
    [btn addSubview:line];
    return btn;
}

//创建 分类 所在地区 送出时间 显示的label
-(UILabel* )createLabelWithButton:(UIButton* )button {
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_X_LABEL*2 + WIDTH_LABEL, (button.frame.size.height - 20)/2, button.frame.size.width - SPACE_X_LABEL*3 - WIDTH_LABEL - 16, 20)];
    lab.textColor = COLOR_BLACK1;
    lab.font = FONT_17;
    lab.textAlignment = NSTextAlignmentRight;
    return lab;
}

//创建 上传到我的专柜 按钮
-(UIButton* )createSendButtonWithTitle:(NSString* )titleString {
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - WIDTH_SENDBUTTON)/2, self.detailTV.frame.origin.y + self.detailTV.frame.size.height + 15, WIDTH_SENDBUTTON, HEIGHT_SENDBUTTON)];
    [btn setTitle:titleString forState:UIControlStateNormal];
    btn.backgroundColor = COLOR_BLUE1;
    btn.titleLabel.font = FONT_17;
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(clickedSendButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//点击了 送方付 收方付 1kg内 大于1kg
-(void)clickedSelectedButton:(UIButton* )sender {
    if (sender == self.ziJiFuBtn) {
        self.ziJiFuBtn.selected = YES;
        self.duiFangFuBtn.selected = NO;
    }else if (sender == self.duiFangFuBtn) {
        self.ziJiFuBtn.selected = NO;
        self.duiFangFuBtn.selected = YES;
    }else if (sender == self.oneKgBtn) {
        self.oneKgBtn.selected = YES;
        self.otherKgBtn.selected = NO;
    }else if (sender == self.otherKgBtn) {
        self.oneKgBtn.selected = NO;
        self.otherKgBtn.selected = YES;
    }
}

//点击了 分类 所在地区 送出时间
-(void)clickedCellButton:(UIButton* )sender {
    if (sender.tag == 100) {//分类
        HBCategorySelectViewController* HBCSVC = [[HBCategorySelectViewController alloc]init];
        [HBCSVC returnCategoryCallBack:^(NSString *firstCateName, NSInteger firstCateId, NSString *secondCateName, NSInteger secondCateId) {
            self.classId = secondCateId;
            NSString* secondName = secondCateName;
            self.classLab.text = [NSString stringWithFormat:@"%@", secondName];
        }];
        [self.navigationController pushViewController:HBCSVC animated:NO];
    }else if (sender.tag == 101) {//所在地区
        HBPlaceSelectViewController* HBPSVC = [[HBPlaceSelectViewController alloc]init];
        [HBPSVC returnPlaceCallBack:^(NSString *proviceName, NSInteger proviceId, NSString *cityName, NSInteger cityId, NSString *districtName, NSInteger districtId) {
            self.provinceId = proviceId;
            self.cityId = cityId;
            self.districtId = districtId;
            NSString* shengName = proviceName;
            NSString* shiName = cityName;
            self.placeLab.text = [NSString stringWithFormat:@"%@%@", shengName, shiName];
        }];
        [self.navigationController pushViewController:HBPSVC animated:NO];
    }else if (sender.tag == 102) {//送出时间
        HBSendTimeSelectViewController* HBSTSVC = [[HBSendTimeSelectViewController alloc]init];
        [HBSTSVC returnSendTimeCallBack:^(NSString* timeStr, NSInteger timeId) {
            self.sendTimeId = timeId;
            NSString* timeString = timeStr;
            self.sendTimeLab.text = [NSString stringWithFormat:@"%@", timeString];
        }];
        [self.navigationController pushViewController:HBSTSVC animated:NO];
    }
}

//点击了 +添加照片
-(void)clickedAddPhotoButton:(UIButton* )sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册获取", nil];
    [actionSheet showInView:self.view];
}

//选择拍照或从相册获取
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //拍照
        [self shootPhoto];
    }else if (buttonIndex == 1) {
        //从相册中选择
        [self pickPhotos];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (UIButton* btn in self.addPhotoView.subviews) {
        if (btn != self.addPhotoBtn) {
            [btn removeFromSuperview];
        }
    }
    if (self.imageArr.count == 0) {
        self.addPhotoBtn.hidden = NO;
        self.addPhotoBtn.frame = CGRectMake(SPACE_PHOTO, SPACE_PHOTO, WIDTH_PHOTO, WIDTH_PHOTO);
    }else if (self.imageArr.count > 0 && self.imageArr.count <= 8) {
        if (self.imageArr.count >= 4) {
            self.addPhotoView.frame = CGRectMake(self.addPhotoView.frame.origin.x, self.addPhotoView.frame.origin.y, self.addPhotoView.frame.size.width, SPACE_PHOTO*3 + WIDTH_PHOTO*2);
        }else if (self.imageArr.count < 4) {
            self.addPhotoView.frame = CGRectMake(self.addPhotoView.frame.origin.x, self.addPhotoView.frame.origin.y, self.addPhotoView.frame.size.width, SPACE_PHOTO*2 + WIDTH_PHOTO);
        }
        for (int i = 0; i < self.imageArr.count; i++) {
            UIButton* button = [self createImageButtonWithRect:CGRectMake(SPACE_PHOTO+(WIDTH_PHOTO+SPACE_PHOTO)*(i%4), (WIDTH_PHOTO+SPACE_PHOTO)*(i/4)+SPACE_PHOTO, WIDTH_PHOTO, WIDTH_PHOTO) AndImage:self.imageArr[i]];
            button.tag = i+1;
            [self.addPhotoView addSubview:button];
        }
        if (self.imageArr.count == 8) {
            self.addPhotoBtn.hidden = YES;
        }else {
            self.addPhotoBtn.hidden = NO;
            self.addPhotoBtn.frame = CGRectMake(SPACE_PHOTO+(WIDTH_PHOTO+SPACE_PHOTO)*(self.imageArr.count%4), (WIDTH_PHOTO+SPACE_PHOTO)*(self.imageArr.count/4)+SPACE_PHOTO, WIDTH_PHOTO, WIDTH_PHOTO);
        }
    }
    self.otherView.frame = CGRectMake(self.otherView.frame.origin.x, self.addPhotoView.frame.origin.y + self.addPhotoView.frame.size.height, self.otherView.frame.size.width, self.otherView.frame.size.height);
    
    [self.scrollView setContentSize:CGSizeMake(0, self.otherView.frame.origin.y + self.otherView.frame.size.height)];
}

//选择好照片后将照片设置成按钮的背景图
-(UIButton* )createImageButtonWithRect:(CGRect )rect AndImage:(UIImage* )image{
    UIButton* btn = [[UIButton alloc]initWithFrame:rect];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedImageButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//点击了图片
-(void)clickedImageButton:(UIButton* )sender {
    HBCheckDetailImageViewController* HBCheckDetailImageVC = [[HBCheckDetailImageViewController alloc]init];
    HBCheckDetailImageVC.imageArray = self.imageArr;
    HBCheckDetailImageVC.selectedImage = [sender imageForState:UIControlStateNormal];
    HBCheckDetailImageVC.currentIndex = sender.tag - 1;
    HBCheckDetailImageVC.HBPZGXVC = self;
    [self.navigationController pushViewController:HBCheckDetailImageVC animated:NO];
}

//拍照
-(void)shootPhoto {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//拍完照后获取照片
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *tempImage= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.imageArr addObject:tempImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//从相册获取照片
-(void)pickPhotos {
    ZYQAssetPickerController* picker =  [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 8 - self.imageArr.count;
    picker.minimumNumberOfSelection = 0;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [self.imageArr addObject:tempImg];
    }
}

//宝贝标题 是否为空
-(BOOL )isTextWithTextField:(UITextField* )tf {
    if (tf.text.length != 0) {
        return YES;
    }else {
        return NO;
    }
}

//分类 所在地区 送出时间 是否为空
-(BOOL )isTextWithLabel:(UILabel* )label {
    if (label.text.length != 0) {
        return YES;
    }else {
        return NO;
    }
}

//付费方式 物品重量 是否已选
-(BOOL )isSelectedButtonWithButton1:(UIButton* )button1 AndButton2:(UIButton* )button2 {
    if (button1.selected == YES || button2.selected == YES) {
        return YES;
    }else {
        return NO;
    }
}

//区分付费方式 物品重量
-(int )compareSelectWayWithButton1:(UIButton* )button1 AndButton2:(UIButton* )button2 {
    if (button1.selected) {
        return 0;
    }else if (button2.selected) {
        return 1;
    }else {
        return -1;
    }
}

//创建alertView
-(UIAlertView* )createAlertViewWithMessage:(NSString* )messageStr {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:messageStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    return av;
}

//点击了 上传到我的专柜
-(void)clickedSendButton:(UIButton* )sender {
    NSLog(@"上传到我的专柜");
    
    if ([self isTextWithTextField:self.titleTF]) {
        if (self.imageArr.count != 0) {
            if ([self isTextWithLabel:self.classLab]) {
                if ([self isSelectedButtonWithButton1:self.ziJiFuBtn AndButton2:self.duiFangFuBtn]) {
                    if ([self isSelectedButtonWithButton1:self.oneKgBtn AndButton2:self.otherKgBtn]) {
                        if ([self isTextWithLabel:self.placeLab]) {
                            if ([self isTextWithLabel:self.sendTimeLab]) {
                                
                                [self sendImageData];
                                
                            }else {
                                UIAlertView* av = [self createAlertViewWithMessage:@"请选择送出时间"];
                                [av show];
                            }
                        }else {
                            UIAlertView* av = [self createAlertViewWithMessage:@"请选择所在地区"];
                            [av show];
                        }
                    }else {
                        UIAlertView* av = [self createAlertViewWithMessage:@"请选择物品重量"];
                        [av show];
                    }
                }else {
                    UIAlertView* av = [self createAlertViewWithMessage:@"请选择付费方式"];
                    [av show];
                }
            }else {
                UIAlertView* av = [self createAlertViewWithMessage:@"请选择物品分类"];
                [av show];
            }
        }else {
            UIAlertView* av = [self createAlertViewWithMessage:@"请选择图片"];
            [av show];
        }
    }else {
        UIAlertView* av = [self createAlertViewWithMessage:@"宝贝标题不能为空"];
        [av show];
    }
}

//显示进度提示
-(void)createAlertView {
    NSString* avMessage = [NSString stringWithFormat:@"已完成0/%ld", self.imageArr.count];
    self.atv = [[UIAlertView alloc]initWithTitle:nil message:avMessage delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [self.atv show];
}

//删除进度提示
-(void)deleteAlertView {
    [self.atv dismissWithClickedButtonIndex:0 animated:YES];
    [self.atv removeFromSuperview];
}

//上传照片
-(void)sendImageData {
    self.imagePathArr = [NSMutableArray array];
    
    id<ALBBOSSServiceProtocol> ossService = [ALBBOSSServiceProvider getService];
    OSSBucket *bucket = [ossService getBucket:ALIYUNOSS_BUCKET_GOODS];
    
    [self createAlertView];
    
    for (int i = 0; i < self.imageArr.count; i++) {
        UIImage* img = self.imageArr[i];
        NSData* imageData = UIImageJPEGRepresentation(img, 0.3);
        NSString* imageType = [self returnImageTypeWithImageData:imageData];//判断img是jpg还是png类型
        NSString* imageName = [self composeImageNameWithImage:img AndImageCount:i AndImageType:imageType];//阿里云OSS中Object的key
        NSString* contentType = [NSString stringWithFormat:@"image/%@", imageType];//content中type的值
        OSSData* testData = [ossService getOSSDataWithBucket:bucket key:imageName];
        [testData setData:imageData withType:contentType];
        
//        NSLog(@"count=%d,imageType=%@,imageName=%@,contentType=%@", i, imageType, imageName, contentType);
        
        [testData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                NSLog(@"ALiYunOSS uploadData Succeed:%d",i);
                
                NSString* imagePath = [self composeImagePathWithImageName:imageName];
                [self.imagePathArr addObject:imagePath];
                
                self.atv.message = [NSString stringWithFormat:@"已完成%ld/%ld", self.imagePathArr.count ,self.imageArr.count];
                
                if (self.imagePathArr.count == self.imageArr.count) {
                    
                    [self sendGoodsInfoData];
                }
            } else {
                NSLog(@"errorInfo_testDataUploadWithProgress:%@", [error userInfo]);
            }
        } withProgressCallback:^(float progress) {
            NSLog(@"current get %f", progress);
        }];
    }
}

//上传物品其它信息
-(void)sendGoodsInfoData {
//    将照片路径转json格式
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self.imagePathArr options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
//    邮费付费方式 0:送方付 1:收方付
    int payWay = [self compareSelectWayWithButton1:self.ziJiFuBtn AndButton2:self.duiFangFuBtn];
//    物品重量 0:小于1kg 1:大于1kg
    int goodsWeight = [self compareSelectWayWithButton1:self.oneKgBtn AndButton2:self.otherKgBtn];
    
//    宝贝详情
    NSString* descriptionStr;
    if (![self.detailTV.text isEqualToString:self.detailTV.placeholder] && self.detailTV.text.length > 0) {
        descriptionStr = self.detailTV.text;
    }
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/publishGoods.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"goodsName=%@&goodsSort=%ld&imagesPathJson=%@&goodsProvince=%ld&goodsCity=%ld&goodsDistrict=%ld&goodsWeight=%d&goodsPostageType=%d&tag=%@&goodsExpireTime=%ld&receiverId=%@&description=%@&myId=%ld&apiKey=%@", self.titleTF.text, self.classId, jsonString, self.provinceId, self.cityId, self.districtId, goodsWeight, payWay, @"", self.sendTimeId, @"", descriptionStr, USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"result_String=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]intValue] == 1) {
                
                NSLog(@"上传物品到我的专柜成功");
                
                [self deleteAlertView];
                
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"上传成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                av.tag = 2;
                [av show];
                
            }else if ([jsonDic[@"status"]intValue] == -1) {
                NSLog(@"参数错误");
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"上传失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }else if ([jsonDic[@"status"]intValue] == -2) {
                NSLog(@"用户不想接受物品");
            }
        });
    }];
}

#pragma mark- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//判断照片类型 @"jpg" @"png"
-(NSString* )returnImageTypeWithImageData:(NSData* )imageData {
    if (imageData.length > 4) {
        const unsigned char * bytes = [imageData bytes];
        
        if (bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4e &&
            bytes[3] == 0x47) {
            return @"png";
        }else if (bytes[0] == 0xff &&
                  bytes[1] == 0xd8 &&
                  bytes[2] == 0xff) {
            return @"jpg";
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}

//根据self.imageArr合成照片名称 fileName = "HeartBeat_"+timeStamp+"_"+imageCount+"_"+userId+"."+type;
-(NSString* )composeImageNameWithImage:(UIImage* )imag AndImageCount:(int )imageCount AndImageType:(NSString* )imageType {
    NSString* timeStamp = [[HBTool shareTool]currentTimeStamp];
    
    return [NSString stringWithFormat:@"HeartBeat_%@_%d_%ld.%@", timeStamp, imageCount, USERID, imageType];
}

//根据照片名称合成照片路径
-(NSString* )composeImagePathWithImageName:(NSString* )imageName {
    return [NSString stringWithFormat:@"http://%@.%@/%@", ALIYUNOSS_BUCKET_GOODS, ALIYUNOSS_HOSTID, imageName];
}


//键盘即将出现
- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = rect.origin.y;
    double duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    NSInteger curve = [[notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue];
    
    CGRect containerFrame = CGRectMake(0, NAVIGATIOINBARHEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - NAVIGATIOINBARHEIGHT);
    containerFrame.size = CGSizeMake(containerFrame.size.width, containerFrame.size.height - keyboardHeight);
    
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        self.scrollView.frame = containerFrame;
        
        if (self.detailTV.isFirstResponder) {
            self.scrollView.contentOffset = CGPointMake(0, self.tfView.frame.size.height + self.addPhotoView.frame.size.height + self.otherView.frame.size.height - keyboardHeight + self.detailTV.frame.size.height);
        }
    } completion:^(BOOL finished) {
        [self.scrollView setContentSize:CGSizeMake(0, self.otherView.frame.origin.y + self.otherView.frame.size.height)];
    }];
}

//键盘即将消失
- (void)keyboardWillHide:(NSNotification *)notif {
    double duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    NSInteger curve = [[notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue];
    
    CGRect containerFrame = CGRectMake(0, NAVIGATIOINBARHEIGHT, self.view.frame.size.width, self.view.bounds.size.height - NAVIGATIOINBARHEIGHT);
    
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        self.scrollView.frame = containerFrame;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        [self.scrollView setContentSize:CGSizeMake(0, self.otherView.frame.origin.y + self.otherView.frame.size.height)];
    }];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self titleTFAndDetailTVResignFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)titleTFAndDetailTVResignFirstResponder {
    if ([self.titleTF isFirstResponder ]) {
        [self.titleTF resignFirstResponder];
    }
    if ([self.detailTV isFirstResponder]) {
        [self.detailTV resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
