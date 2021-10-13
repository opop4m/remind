const int typePerson = 1;
const int typeGroup = 2;
const int typeAssistant = 3;

const int msgTypeText = 1;
const int msgTypeImage = 2;
const int msgTypeVoice = 3;
const int msgTypeVideo = 4;
const int msgTypeVoiceCall = 5;
const int msgTypeVideoCall = 6;
const int msgTypeTips = 7;

const int tipsTypeJoin = 1;
const int tipsTypeQuit = 2;
const int tipsTypeGroupNotice = 3;
const int tipsTypeGroupNameChange = 4;

const int msgStateSending = 1;
const int msgStateArrived = 2;
const int msgStateReaded = 3;
const int msgStateFailed = -1;

const int genderUnknow = 0;
const int genderMale = 1;
const int genderFemale = 2;

String genderFromEnum(int i) {
  if (i == genderMale) {
    return "男";
  } else {
    return "女";
  }
}

const int PopTypeP2P = 1;
const int PopTypeGroup = 2;
const int PopTypeNewFriend = 3;
const int PopTypePosts = 4;

const int statusAgree = 1;
const int statusRefuse = 2;
