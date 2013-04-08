//
//  ViewController.m
//  SlideShow
//
//  Created by 廣川政樹 on 2013/04/08.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  //スライドショーの設定
  [self initSlideShowImages];
  //スライドショーで表示する画像を初期化
  [self initSlideShowImageView];
  //スライドショー開始
  [self startSlideShow];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


//スライドショーで表示するイメージを初期化
- (void)initSlideShowImages
{
  //スライドショーで使用する画像タイトル定義
  self.slideShowImages = [NSArray arrayWithObjects:
                          @"Pandora",
                          @"Rain",
                          @"Echidna",
                          @"Heimatlos",
                          @"Hesychasm",
                          @"Asymmetry",
                          @"Loki",
                          @"El",
                          @"Frigg",
                          @"Beelzebub",
                          @"Hirume",
                          @"Hera",
                          @"Nyx",
                          @"Maldoror",
                          @"7thVision",
                          @"MariaMagdalena",
                          @"Sarah",
                          @"AngelsBone",
                          @"Isthar",
                          @"Lilit",
                          @"Icon",
                          @"cintaamaNicakra",
                          @"samanta-bhadra",
                          nil];
  //総画像ファイル数を取得
  self.slideShowImageNum = [self.slideShowImages count] - 1;
  //最初に表示する画像IDを設定
  self.currentImageIndex = 0;
  //スライドが切り替わる秒数を設定
  self.slideShowTimerInterval = 5.0f;
  //フェードイン秒数
  self.slideShowFadeInDuration = 0.3;
  //画像の横幅
  self.imageWidth = 320;
  //画像の縦幅
  self.imageHeight = 568;
}

//スライドショーで表示するイメージを配置
- (void)initSlideShowImageView
{
  //UIImageViewを初期化
  self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageWidth, self.imageHeight)];
  //UIImageViewに画像を表示
  self.imageView.image = [self getUIImageFromResources:[self.slideShowImages objectAtIndex:self.currentImageIndex] ext:@"jpg"];
  //UIImageViewを UIViewに乗せる
  UIView *slideShowView = [[UIView alloc] init];
  slideShowView = self.imageView;
  //ステージに配置
  [self.view addSubview:slideShowView];
}

//スライドショーを開始する
- (void)startSlideShow
{
  //既にスライドショーが再生中であれば実行しない
  if (self.isRunningSlideShow) {
    return;
  }
  //最後の画像になったらIDをリセットする
  if ([self isLastImage]) {
    self.currentImageIndex = -1;
  }
  //スライドショーのタイマー定義
  self.slideShowTimer = [NSTimer scheduledTimerWithTimeInterval:self.slideShowTimerInterval
                                                         target:self
                                                       selector:@selector(nextSlideShow:)
                                                       userInfo:nil
                                                        repeats:YES];
  //スライドショー再生中フラグ
  self.isRunningSlideShow = YES;
}

//スライドショーで次の写真を表示する
- (void)nextSlideShow:(NSTimer*)timer
{
  //最後の画像になったらIDをリセットする
  if ([self isLastImage]) {
    self.currentImageIndex = -1;
  }
  //次の画像を表示
  [self changeToNextImage];
}

//次の画像へ切り替える
- (void)changeToNextImage
{
  //画像IDを送る
  self.currentImageIndex++;
  //画像ファイル名をセット
  NSString *imageTitle = [NSString stringWithFormat:@"%@", [self.slideShowImages objectAtIndex:self.currentImageIndex]];
  self.imageView.image = [self getUIImageFromResources:imageTitle ext:@"jpg"];
  //フェードイン開始
  _imageView.alpha = 0;
  [UIView beginAnimations:@"fadeIn" context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:self.slideShowFadeInDuration];
  _imageView.alpha = 1;
  [UIView commitAnimations];
}

//スライドショーを停止する
- (void)stopSlideShow
{
  [self.slideShowTimer invalidate];
  self.isRunningSlideShow = NO;
}

//スライドショーイベントの呼び出し
- (void)callSlideShow
{
  if (self.isRunningSlideShow) {
    [self stopSlideShow];
  } else {
    [self startSlideShow];
  }
  self.isRunningSlideShow = !self.isRunningSlideShow;
}

//最後のイメージであるか
- (BOOL)isLastImage
{
  return (self.slideShowImageNum <= self.currentImageIndex);
}

//画像ファイルを取得
- (UIImage *)getUIImageFromResources:(NSString*)fileName ext:(NSString*)ext
{
  NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
  UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
  return img;
}

@end
