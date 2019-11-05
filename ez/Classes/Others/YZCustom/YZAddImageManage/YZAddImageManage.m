//
//  YZAddImageManage.m
//  ez
//
//  Created by dahe on 2019/7/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZAddImageManage.h"

@interface YZAddImageManage ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation YZAddImageManage

- (void)addImage
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相机功能是否可用，调用相机
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            [MBProgressHUD showError:@"相机不可用"];
            return;
        }
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相册功能是否可用，调用相册
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
            [MBProgressHUD showError:@"相册不可用"];
            return;
        }
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = NO;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.viewController presentViewController:alertController animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage * croppedImage_ = [YZTool imageCompressionWithImage:image];
    if (_delegate && [_delegate respondsToSelector:@selector(imageManageCropImage:)]) {
        [_delegate imageManageCropImage:croppedImage_];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}


@end
