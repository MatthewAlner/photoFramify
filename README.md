# PhotoFramify

## tl;dr

PhotoFramify is a bash script to batch process a bunch of images making them ready for a digital photo frame.

It resizes the images to the provided resolution, and for the images that don't have the same aspect ratio ratio as the digital photo frame a blurred version of the image is used in the background.

|           Input           |    |          Output         |
|:-------------------------:|----|:-----------------------:|
|  ![9x16-orig][9x16-orig]  | => |  ![9x16-416][9x16-416]  |

### usage

This script relies on `imagemagick` being available on the path.

On a mac with brew `brew install imagemagick`

Then
``` bash
cd ~/user/pictures/some-folder-with-images
bash ~/path-where-you-cloned-this-repo/photoFramify.sh
```

This will generate a `OUTPUT` folder with the processed images

## --verbose

There are some available config options which can be provided as flags.

| Setting               | Flag               | Default | Type    | Description                                                  |
|-----------------------|--------------------|---------|---------|--------------------------------------------------------------|
| NAME_OF_OUTPUT_FOLDER | -o --output-folder | OUTPUT  | string  | Name of Output folder                                        |
| MAX_HEIGHT            | -h --max-height    | 1080    | integer | height of your picture frame (px)                            |
| MAX_WIDTH             | -w --max-width     | 1920    | integer | width of your picture frame (px)                             |
| QUALITY               | -q --quality       | 92      | integer | jpeg quality 0-100                                           |
| ADD_BLUR_BACKGROUND   | -b --blur          | true    | boolean | should the blurred background be added                       |
| RENAME_TO_MD5         | -r --rename-to-md5 | true    | boolean | should the output file be renamed to the md5 (prevent dupes) |

Example:
```
photoFramify.sh -o generated -w 1920 -h 1080 -q 80 -b true -r true
```

Benefits

- Smaller file sizes
- No more boring black borders
- No more dupes

### More Examples

| Ratio |           Input           |    |          Output         |
|-------|:-------------------------:|----|:-----------------------:|
| 1:1   |   ![1x1-orig][1x1-orig]   | => |   ![1x1-416][1x1-416]   |
| 3:4   |   ![3x4-orig][3x4-orig]   | => |   ![3x4-416][3x4-416]   |
| 9:16  |  ![9x16-orig][9x16-orig]  | => |  ![9x16-416][9x16-416]  |
| 10:36 | ![10x36-orig][10x36-orig] | => | ![10x36-416][10x36-416] |
| 4:3   |   ![4x3-orig][4x3-orig]   | => |   ![4x3-416][4x3-416]   |
| 16:9  |  ![16x9-orig][16x9-orig]  | => |  ![16x9-416][16x9-416]  |
| 36:10 | ![36:10-orig][36x10-orig] | => | ![36:10-416][36x10-416] |

### // TODO

- Check this runs on linux (md5 command might need to be md5sum)
- Parallelise?
- Allow path to be passed in

<!-- original -->

[1x1-orig]: http://res.cloudinary.com/automattech/image/upload/c_scale,h_300/v1533056456/photoFramify/original/1x1_vincent-van-zalinge-390780-unsplash.jpg
[3x4-orig]: http://res.cloudinary.com/automattech/image/upload/c_scale,h_300/v1533056455/photoFramify/original/3x4_shownen-kang-757155-unsplash.jpg
[9x16-orig]: http://res.cloudinary.com/automattech/image/upload/c_scale,h_300/v1533056454/photoFramify/original/9x16_kwang-mathurosemontri-110344-unsplash.jpg
[10x36-orig]: http://res.cloudinary.com/automattech/image/upload/c_scale,h_300/v1533056455/photoFramify/original/10x36_brad-knight-757239-unsplash.jpg
[4x3-orig]: http://res.cloudinary.com/automattech/image/upload/c_scale,w_500/v1533056455/photoFramify/original/4x3_elevate-755046-unsplash.jpg
[16x9-orig]: http://res.cloudinary.com/automattech/image/upload/c_scale,w_500/v1533056455/photoFramify/original/16x9_ales-krivec-2050-unsplash.jpg
[36x10-orig]: http://res.cloudinary.com/automattech/image/upload/c_scale,w_500/v1533056455/photoFramify/original/36x10_jack-b-757028-unsplash.jpg

<!-- w416h234 -->

[1x1-416]: http://res.cloudinary.com/automattech/image/upload/v1533056469/photoFramify/w416h234/b1120ed00f1c496519e710d6767fd9fe.jpg
[3x4-416]: http://res.cloudinary.com/automattech/image/upload/v1533056470/photoFramify/w416h234/f1036e4d4f2a419632f4d504e09a5e73.jpg
[9x16-416]: https://res.cloudinary.com/automattech/image/upload/v1533056469/photoFramify/w416h234/8c134976a3ee07d5254ae466b33cbe8f.jpg
[10x36-416]: http://res.cloudinary.com/automattech/image/upload/v1533056469/photoFramify/w416h234/f1d1de233edcb600b9091f22abb66931.jpg
[4x3-416]: http://res.cloudinary.com/automattech/image/upload/v1533056469/photoFramify/w416h234/c86b967c336f0baecb6a684fed11b6fe.jpg
[16x9-416]: http://res.cloudinary.com/automattech/image/upload/v1533056469/photoFramify/w416h234/8a5399f9d57d70e328e7a15f430113e6.jpg
[36x10-416]: http://res.cloudinary.com/automattech/image/upload/v1533056469/photoFramify/w416h234/b38db11e754260c27c3701d66bc12e1e.jpg

<!-- w1920h1080 -->