//
//  YZAddMultipleImageView.m
//  ez
//
//  Created by dahe on 2019/7/3.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZAddMultipleImageView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YZAddMultipleImageView.h"
#import "YZGridViewFlowLayout.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "MBProgressHUD+MJ.h"

@interface YZAddMultipleImageView ()<TZImagePickerControllerDelegate, YZGridViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSMutableArray *_selectedAssets;
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@end

@implementation YZAddMultipleImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupChildViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.maxImageCount = 6;
    _selectedAssets = [NSMutableArray array];
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, 0, self.width -  2 * YZMargin, 35)];
    self.titleLabel = titleLabel;
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [self addSubview:titleLabel];
    
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    YZGridViewFlowLayout *layout = [[YZGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.tz_width - 2 * _margin - 5) / 4 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.tz_width, _margin * 2 + _itemWH) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.alwaysBounceVertical = NO;
    collectionView.scrollEnabled = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:collectionView];
    [self.collectionView registerClass:[YZAddImageCollectionViewCell class] forCellWithReuseIdentifier:@"AddImageCollectionViewCellID"];
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZAddImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddImageCollectionViewCellID" forIndexPath:indexPath];
    cell.deleteBtn.hidden = NO;
    if (self.images.count == indexPath.row)
    {
        cell.imageView.image = [UIImage imageNamed:@"add_picture"];
        cell.deleteBtn.hidden = YES;
    }else
    {
        id imageObj = self.images[indexPath.row];
        if ([imageObj isKindOfClass:[UIImage class]]) {
            cell.imageView.image = imageObj;
        }else{
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageObj]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    NSInteger index = [self.images indexOfObject:imageURL.absoluteString];
                    [self.images replaceObjectAtIndex:index withObject:image];
                }
            }];
        }
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.images.count == indexPath.row)
    {
        [self chooseResourceIsVideo:NO];
    }else
    {
        if (_selectedAssets.count == self.images.count) {
            [self setImagePickerControllerNav];
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:self.images index:indexPath.row];
            imagePickerVc.maxImagesCount = self.maxImageCount;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                NSMutableArray * images = [NSMutableArray array];
                for (UIImage * photo in photos) {
                    [images addObject:[YZTool imageCompressionWithImage:photo]];
                }
                self.images = [NSMutableArray arrayWithArray:images];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                [self refreshView];
            }];
            [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - 删除照片
- (void)deleteBtnClik:(UIButton *)sender {
    [self.images removeObjectAtIndex:sender.tag];
    
    if (_selectedAssets.count > sender.tag) {
        [_selectedAssets removeObjectAtIndex:sender.tag];
    }
    
    [self refreshView];
}

#pragma mark - 选择视频/照片
- (void)chooseResourceIsVideo:(BOOL)isVideo
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString * action1 = @"拍照";
    if (isVideo) {
        action1 = @"拍摄";
    }
    [alertController addAction:[UIAlertAction actionWithTitle:action1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相机功能是否可用，调用相机
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            [MBProgressHUD showError:@"相机不可用"];
            return;
        }
        [self pushCameraIsVideo:isVideo];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相册功能是否可用，调用相册
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
            [MBProgressHUD showError:@"相册不可用"];
            return;
        }
        [self pushPhotoLibraryIsVideo:isVideo];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

//调用相机
- (void)pushCameraIsVideo:(BOOL)isVideo
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if (isVideo) {
            self.imagePickerVc.mediaTypes = @[(NSString*)kUTTypeMovie];
        }else
        {
            self.imagePickerVc.mediaTypes = @[(NSString*)kUTTypeImage];
        }
        self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.viewController presentViewController:self.imagePickerVc animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        [MBProgressHUD showMessage:@"处理中.." toView:KEY_WINDOW];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(PHAsset *asset, NSError *error) {
            [MBProgressHUD hideHUD];
            [self refreshCollectionViewWithAddedAsset:asset image:image];
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image
{
    [_selectedAssets addObject:asset];
    [self.images addObject:[YZTool imageCompressionWithImage:image]];
    [self refreshView];
}

//调用相册
- (void)pushPhotoLibraryIsVideo:(BOOL)isVideo {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImageCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [self setImagePickerControllerNav];
    
    if (!isVideo) {
        if (self.maxImageCount > 1) {
            imagePickerVc.selectedAssets = _selectedAssets;
        }
        imagePickerVc.allowCrop = YES;
        imagePickerVc.needCircleCrop = NO;
    }
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingVideo = isVideo;
    imagePickerVc.allowPickingImage = !isVideo;
    imagePickerVc.videoMaximumDuration = 10;
    [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    NSMutableArray * images = [NSMutableArray array];
    for (UIImage * photo in photos) {
        [images addObject:[YZTool imageCompressionWithImage:photo]];
    }
    self.images = [NSMutableArray arrayWithArray:images];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    [self refreshView];
}

- (void)setImagePickerControllerNav
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:YZColor(63, 63, 63, 1) WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.item < _images.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    return (sourceIndexPath.item < _images.count && destinationIndexPath.item < _images.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    UIImage *image = _images[sourceIndexPath.item];
    [_images removeObjectAtIndex:sourceIndexPath.item];
    [_images insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    [_collectionView reloadData];
}

- (void)refreshView
{
    [self.collectionView reloadData];
    self.collectionView.height = ((self.images.count + 4) / 4 ) * (_margin + _itemWH) + _margin;
    self.height = CGRectGetMaxY(self.collectionView.frame);
    if (_delegate && [_delegate respondsToSelector:@selector(viewHeightchange)]) {
        [_delegate viewHeightchange];
    }
}
- (CGFloat)getViewHeight
{
    return CGRectGetMaxY(self.collectionView.frame);
}
- (void)setImagesWithImageUrlStrs:(NSArray *)imageUrlStrs
{
    self.images = [NSMutableArray array];
    for (NSString * imageUrlStr in imageUrlStrs) {
        [self.images addObject:[NSString stringWithFormat:@"%@%@", baseUrl,imageUrlStr]];
    }
    [self refreshView];
}

#pragma mark - 初始化
- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        _imagePickerVc.videoMaximumDuration = 10;
    }
    return _imagePickerVc;
}

@end
