//
//  HBChangeMyInfoViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/17.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBChangeMyInfoViewController.h"

@interface HBChangeMyInfoViewController ()

@end

@implementation HBChangeMyInfoViewController


//行高
#define LINE_HEIGHT 50
//label距离左的间距 label的宽高
#define SPACE_X_LABEL 10
#define WIDTH_LABEL 55
#define HEIGHT_LABEL 20
//头像 按钮 宽
#define WIDTH_HEADIVBUTTON 40
//确认保存 按钮 宽高
#define WIDTH_SAVEBUTTON (self.view.frame.size.width/2)
#define HEIGHT_SAVEBUTTON 35
//照片原始最大宽度
#define ORIGINAL_MAX_WIDTH 640.0f

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改信息";
    self.view.backgroundColor = COLOR_WHITE1;
    
    self.infoView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATIOINBARHEIGHT, self.view.frame.size.width, LINE_HEIGHT*6)];
    [self.view addSubview:self.infoView];
    
    [self initButtonView];
    
    [self initCellButton];
    
}

-(void)initCellButton {
    NSArray* stringArr = @[@"头像",@"昵称",@"心跳号",@"性别",@"地区",@"签名"];
    for (int i = 0; i < 6; i++) {
        UIButton* cellButton = [self createCellButtonWithX:0 AndY:i*LINE_HEIGHT AndWidth:self.infoView.frame.size.width AndHeight:LINE_HEIGHT AndLabelText:stringArr[i]];
        cellButton.tag = i+1;
        [self.infoView addSubview:cellButton];
        
        if (i == 0) {
            self.headIV = [[UIImageView alloc]initWithFrame:CGRectMake(cellButton.frame.size.width - SPACE_X_LABEL - WIDTH_HEADIVBUTTON, (LINE_HEIGHT - WIDTH_HEADIVBUTTON)/2, WIDTH_HEADIVBUTTON, WIDTH_HEADIVBUTTON)];
            self.headIV.image = self.headImage;
            self.headIV.layer.cornerRadius = WIDTH_HEADIVBUTTON/2;
            self.headIV.layer.masksToBounds = YES;
            [cellButton addSubview:self.headIV];
        }else if (i == 1) {
            self.nickLab = [self createLabelWithX:SPACE_X_LABEL*2 + WIDTH_LABEL AndY:(LINE_HEIGHT - HEIGHT_LABEL)/2 AndWidth:cellButton.frame.size.width - SPACE_X_LABEL*3 - WIDTH_LABEL AndHeight:HEIGHT_LABEL];
            self.nickLab.text = NICKNAME;
            [cellButton addSubview:self.nickLab];
        }else if (i == 2) {
            self.xinTiaoLab = [self createLabelWithX:SPACE_X_LABEL*2 + WIDTH_LABEL AndY:(LINE_HEIGHT - HEIGHT_LABEL)/2 AndWidth:cellButton.frame.size.width - SPACE_X_LABEL*3 - WIDTH_LABEL AndHeight:HEIGHT_LABEL];
            self.xinTiaoLab.text = HEARTBEATNUMBER;
            [cellButton addSubview:self.xinTiaoLab];
        }else if (i == 3) {
            self.sexLab = [self createLabelWithX:SPACE_X_LABEL*2 + WIDTH_LABEL AndY:(LINE_HEIGHT - HEIGHT_LABEL)/2 AndWidth:cellButton.frame.size.width - SPACE_X_LABEL*3 - WIDTH_LABEL AndHeight:HEIGHT_LABEL];
            self.sexLab.text = GENDER;
            [cellButton addSubview:self.sexLab];
        }else if (i == 4) {
            self.placeLab = [self createLabelWithX:SPACE_X_LABEL*2 + WIDTH_LABEL AndY:(LINE_HEIGHT - HEIGHT_LABEL)/2 AndWidth:cellButton.frame.size.width - SPACE_X_LABEL*3 - WIDTH_LABEL AndHeight:HEIGHT_LABEL];
            self.placeLab.text = self.placeString;
            [cellButton addSubview:self.placeLab];
        }else if (i == 5) {
            self.personalSignLab = [self createLabelWithX:SPACE_X_LABEL*2 + WIDTH_LABEL AndY:(LINE_HEIGHT - HEIGHT_LABEL)/2 AndWidth:cellButton.frame.size.width - SPACE_X_LABEL*3 - WIDTH_LABEL AndHeight:HEIGHT_LABEL];
            self.personalSignLab.text = PERSONALIZEDSIGNATURE;
            [cellButton addSubview:self.personalSignLab];
        }
    }
}

-(void)initButtonView {
    self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, self.infoView.frame.origin.y + self.infoView.frame.size.height, self.view.frame.size.width, HEIGHT_SAVEBUTTON + 15)];
    UIButton* saveBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.buttonView.frame.size.width - WIDTH_SAVEBUTTON)/2, self.buttonView.frame.size.height - HEIGHT_SAVEBUTTON, WIDTH_SAVEBUTTON, HEIGHT_SAVEBUTTON)];
    saveBtn.backgroundColor = COLOR_BLUE1;
    saveBtn.titleLabel.font = FONT_20;
    [saveBtn setTitle:@"完成" forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 4;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(clickedSavedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:saveBtn];
    [self.view addSubview:self.buttonView];
}

-(UIButton* )createCellButtonWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height AndLabelText:(NSString* )textString {
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    [btn addTarget:self action:@selector(clickedCellButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_X_LABEL, (LINE_HEIGHT - HEIGHT_LABEL)/2, WIDTH_LABEL, HEIGHT_LABEL)];
    lab.text = textString;
    lab.textColor = COLOR_BLACK1;
    lab.font = FONT_17;
    [btn addSubview:lab];
    
    UIImageView* lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, LINE_HEIGHT - 1, btn.frame.size.width, 1)];
    lineIV.image = [UIImage imageNamed:@"line.png"];
    [btn addSubview:lineIV];
    
    return btn;
}

-(UILabel* )createLabelWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height {
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    lab.textColor = COLOR_GRAY1;
    lab.textAlignment = NSTextAlignmentRight;
    lab.font = FONT_17;
    return lab;
}

//点击cellButton
-(void)clickedCellButton:(UIButton* )sender {
    if (sender.tag == 1) {//头像
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册获取", nil];
        actionSheet.tag = 20;
        [actionSheet showInView:self.view];
        
    }else if (sender.tag == 2) {//昵称
        HBChangeNickNameViewController* HBNickNameVC = [[HBChangeNickNameViewController alloc]init];
        [HBNickNameVC returnText:^(NSString *showText) {
            if (showText.length > 0) {
                self.nickLab.text = showText;
            }
        }];
        [self.navigationController pushViewController:HBNickNameVC animated:NO];
        
    }else if (sender.tag == 3) {//心跳号
        HBChangeHBNumberViewController* HBChangeNumberVC = [[HBChangeHBNumberViewController alloc]init];
        [HBChangeNumberVC returnText:^(NSString *showText) {
            if (showText.length > 0) {
                self.xinTiaoLab.text = showText;
            }
        }];
        [self.navigationController pushViewController:HBChangeNumberVC animated:NO];
        
    }else if (sender.tag == 4) {//性别
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"女", @"男", nil];
        actionSheet.tag = 21;
        [actionSheet showInView:self.view];
        
    }else if (sender.tag == 5) {//地区
        HBPlaceSelectViewController* HBPSVC = [[HBPlaceSelectViewController alloc]init];
        [HBPSVC returnPlaceCallBack:^(NSString *proviceName, NSInteger proviceId, NSString *cityName, NSInteger cityId, NSString *districtName, NSInteger districtId) {
            NSString* shengName = proviceName;//省名
            NSString* shiName = cityName;//市名
            self.placeLab.text = [NSString stringWithFormat:@"%@%@", shengName, shiName];
            
            //更新 地区
            NSInteger provinceID = proviceId;
            NSInteger cityID = cityId;
            [self modifyPlaceWithProvinceID:provinceID AndCityID:cityID];
        }];
        [self.navigationController pushViewController:HBPSVC animated:NO];
        
    }else if (sender.tag == 6) {//个性签名
        HBPersonalSignViewController* HBPSVC = [[HBPersonalSignViewController alloc]init];
        [HBPSVC returnText:^(NSString *showText) {
            if (showText.length > 0) {
                self.personalSignLab.text = showText;
            }
        }];
        [self.navigationController pushViewController:HBPSVC animated:NO];
        
    }else {
        
    }
}

//更新 地区
-(void)modifyPlaceWithProvinceID:(NSInteger )provinceID AndCityID:(NSInteger )cityID {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/modifyAddr.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"myId=%ld&apiKey=%@&provinceId=%ldcityId=%ld", USERID, APIKEY, provinceID, cityID];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSLog(@"更新 地区 成功");
            }
        });
    }];
}

//更改 性别
-(void)modifyGenderWithGender:(NSInteger )genderInteger {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/modifyGender.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"myId=%ld&apiKey=%@&gender=%ld", USERID, APIKEY, genderInteger];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSLog(@"更改 性别 成功");
            }
        });
    }];
}

-(void)clickedSavedButton:(UIButton* )sender {
    
    HBShareViewController* HBShareVC = [[HBShareViewController alloc]init];
    HBNavigationController* HBNavi = [[HBNavigationController alloc]initWithRootViewController:HBShareVC];
    [self.navigationController presentViewController:HBNavi animated:NO completion:^{
        
    }];
    
}

#pragma mark- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 20) {
        if (buttonIndex == 0) {//拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     
                                 }];
            }
        }else if (buttonIndex == 1) {//从相册获取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     
                                 }];
            }
        }
    }else if (actionSheet.tag == 21) {
        if (buttonIndex == 0) {//女
            self.sexLab.text = @"女";
            [self modifyGenderWithGender:0];
        }else if (buttonIndex == 1) {//男
            self.sexLab.text = @"男";
            [self modifyGenderWithGender:1];
        }
    }
}

//上传头像
-(void)sendAvatarWithImage:(UIImage* )img {
    id<ALBBOSSServiceProtocol> ossService = [ALBBOSSServiceProvider getService];
    OSSBucket *bucket = [ossService getBucket:ALIYUNOSS_BUCKET_AVATAR];
    
    NSData* imageData = UIImageJPEGRepresentation(img, 0.5);
    NSString* imageType = [self returnImageTypeWithImageData:imageData];//判断img是jpg还是png类型
    NSString* imageName = [self composeImageNameWithImage:img AndImageCount:0 AndImageType:imageType];//阿里云OSS中Object的key
    NSString* contentType = [NSString stringWithFormat:@"image/%@", imageType];//content中type的值
    OSSData* testData = [ossService getOSSDataWithBucket:bucket key:imageName];
    [testData setData:imageData withType:contentType];
    
    [testData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            NSString* imagePath = [self composeImagePathWithImageName:imageName];
            
            [self modifyAvatarWithImagePath:imagePath];
            
        } else {
            NSLog(@"errorInfo_testDataUploadWithProgress:%@", [error userInfo]);
        }
    } withProgressCallback:^(float progress) {
        NSLog(@"current get %f", progress);
    }];
}

//更新头像
-(void)modifyAvatarWithImagePath:(NSString* )imagePath {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/modifyAvatar.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"myId%ld&apiKey=%@&userAvatarPath=%@", USERID, APIKEY, imagePath];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                
            }
        });
    }];
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
    return [NSString stringWithFormat:@"http://%@.%@/%@", ALIYUNOSS_BUCKET_AVATAR, ALIYUNOSS_HOSTID, imageName];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
        [self sendAvatarWithImage:editedImage];
        self.headIV.image = editedImage;
        
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:2.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
