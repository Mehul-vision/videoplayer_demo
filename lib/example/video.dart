import 'dart:io';

Socket socket;
const mockImage =
    'http://baishan.oversketch.com/2019/11/05/1f676c8e4036fa5080892c5294c8e90b.PNG';
const mockVideo =
    'http://baishan.oversketch.com/2019/11/05/d07f2f1440e51b9680f4bcfe63b0ab67.MP4';
const mV2 =
    'http://baishan.oversketch.com/2020/05/14/32f5e6da40947c9880598b4d8b3671f4.MP4';
const mV3 =
    'http://baishan.oversketch.com/2020/05/14/55eae3664003437b80a159a9f2369474.MP4';
const mV4 =
    'http://baishan.oversketch.com/2020/05/14/59e0c1dd40bd4f41804f33814ad4b67a.MP4';

const mV5 =
    'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4';
const mV6 =
    'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4';

const mV7 =
    'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4';

const mV8 =
    'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';

class UserVideo {
  final String url;
  final String image;
  final String desc;

  UserVideo({
    this.url: mockVideo,
    this.image: mockImage,
    this.desc,
  });

  static UserVideo get test =>
      UserVideo(image: '', url: mV2, desc: 'MV_TEST_2');

  static List<UserVideo> fetchVideo() {
    List<UserVideo> list = [];
    list.add(UserVideo(image: '', url: mockVideo, desc: 'video'));
    list.add(UserVideo(image: '', url: mV2, desc: 'MV_TEST_2'));
    list.add(UserVideo(image: '', url: mV7, desc: 'MV_TEST_7'));
    list.add(UserVideo(image: '', url: mV8, desc: 'MV_TEST_8'));
    list.add(UserVideo(image: '', url: mV3, desc: 'MV_TEST_3'));
    list.add(UserVideo(image: '', url: mV5, desc: 'MV_TEST_5'));
    list.add(UserVideo(image: '', url: mV6, desc: 'MV_TEST_6'));
    list.add(UserVideo(image: '', url: mV4, desc: 'MV_TEST_4'));
    return list;
  }

  @override
  String toString() {
    return 'image:$image' '\nvideo:$url';
  }
}
