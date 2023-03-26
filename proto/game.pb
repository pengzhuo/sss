
˝C
proto/game.protoxsdq"û
Player
seat (Rseat
player (	Rplayer
info (	Rinfo
status (Rstatus
	is_online (RisOnline
total_score (R
totalScore"s
Meld
type (Rtype 
cards (2
.xsdq.CardRcards

start_card (R	startCard
action (Raction"
Card
card (Rcard"2
Dice
dice1 (Rdice1
dice2 (Rdice2"â
Prompt
	action_id (RactionId
prompt (Rprompt%
ref_card (2
.xsdq.CardRrefCard#
op_card (2
.xsdq.CardRopCard"\
CardTip
card (2
.xsdq.CardRcard
points (Rpoints
rest_cnt (RrestCnt"Ø
CreateRoomRequest
room_id (RroomId
owner (	Rowner
kwargs (	Rkwargs
	room_uuid (	RroomUuid
club_id (RclubId

owner_info (	R	ownerInfo"(
CreateRoomResponse
code (Rcode"§
DealResponse
dealer_uuid (	R
dealerUuid
dice (2
.xsdq.DiceRdice.
cards_in_hand (2
.xsdq.CardRcardsInHand#
current_round (RcurrentRound"É
DiscardTipsResponse
seat (Rseat
timer (Rtimer
	new_round (RnewRound%
show_surrender (RshowSurrender"0
DiscardRequest
meld (2
.xsdq.MeldRmeld"Y
DiscardResponse
uid (	Ruid
meld (2
.xsdq.MeldRmeld
first (Rfirst"ó
DismissRoomWebRequest
room_id (RroomId
	game_type (RgameType
app_id (RappId
owner (	Rowner
	room_uuid (	RroomUuid"è
DismissRoomWebResponse
code (Rcode
room_id (RroomId
	game_type (RgameType
app_id (RappId
owner (	Rowner"
DismissRoomRequest"Õ
DismissRoomResponse
code (Rcode
flag (Rflag!
sponsor_type (RsponsorType#
agree_players (	RagreePlayers'
decline_players (	RdeclinePlayers

has_settle (R	hasSettle"Ç
EnterRoomOtherResponse
code (Rcode
player (	Rplayer
seat (Rseat
info (	Rinfo
score (Rscore"®
EnterRoomWebResponse
code (Rcode
room_id (RroomId
player (	Rplayer
	game_type (RgameType
app_id (RappId
club_id (RclubId"W
EnterRoomRequest
room_id (RroomId
player (	Rplayer
info (	Rinfo"Ô
EnterRoomResponse
code (Rcode
room_id (RroomId
owner (	Rowner
kwargs (	Rkwargs

rest_cards (R	restCards$
player (2.xsdq.PlayerRplayer

owner_info (	R	ownerInfo
	room_uuid (	RroomUuid".
ExistRoomWebRequest
room_id (RroomId"*
ExistRoomWebResponse
flag (Rflag"ß
ExitRoomWebResponse
code (Rcode
room_id (RroomId
player (	Rplayer
	game_type (RgameType
app_id (RappId
club_id (RclubId"
ExitRoomRequest"R
ExitRoomResponse
code (Rcode
player (	Rplayer
flag (Rflag"
HeartbeatRequest"
HeartbeatResponse"F
OnlineStatusResponse
player (	Rplayer
status (Rstatus""
PassResponse
seat (Rseat"'
PlayerVoteRequest
flag (Rflag"c
PlayerVoteResponse
flag (Rflag
player (	Rplayer!
sponsor_type (RsponsorType"
ReadyRequest"'
ReadyResponse
player (	Rplayer"≤	
ReconnectResponse
code (Rcode
room_id (RroomId
	room_uuid (	RroomUuid
kwargs (	Rkwargs

owner_uuid (	R	ownerUuid

owner_info (	R	ownerInfo
room_status (R
roomStatus#
current_round (RcurrentRound#
landlord_seat	 (RlandlordSeat
dealer_seat
 (R
dealerSeat
active_seat (R
activeSeat
max_seat (RmaxSeat
timer (Rtimer6
player (2.xsdq.ReconnectResponse.PlayerRplayer-
bottom_cards (2
.xsdq.CardRbottomCards!
master_color (RmasterColor
master_seat (R
masterSeat!
friend_color (RfriendColor
change_seat (R
changeSeat
mingji (Rmingji
teams (	Rteams
table_score (R
tableScore%
show_surrender (RshowSurrender

first_seat (R	firstSeat
	bury_seat (RburySeat

rebel_seat (R	rebelSeatﬁ
Player
seat (Rseat
player (	Rplayer
info (	Rinfo
status (Rstatus
	is_online (RisOnline
round_score (R
roundScore
total_score (R
totalScore.
cards_in_hand (2
.xsdq.CardRcardsInHand$
discard	 (2
.xsdq.MeldRdiscard
robot
 (Rrobot
point (Rpoint
	rob_color (RrobColor"ß
RefundWebResponse
code (Rcode
room_id (RroomId
	game_type (RgameType
app_id (RappId
owner (	Rowner
	room_uuid (	RroomUuid"ò
RunningWebResponse
sessions (Rsessions
players (Rplayers%
tables_initial (RtablesInitial%
tables_playing (RtablesPlaying"w
ScoreResponse2
player (2.xsdq.ScoreResponse.PlayerRplayer2
Player
seat (Rseat
score (Rscore"Ò
SettleForRoomResponse
flag (RflagG
player_data (2&.xsdq.SettleForRoomResponse.PlayerDataR
playerData˙

PlayerData
player (	Rplayer
seat (Rseat
total_score (R
totalScore
	top_score (RtopScore
win_cnt (RwinCnt
lose_cnt (RloseCnt
	top_level (RtopLevel
is_owner (RisOwner
status	 (Rstatus"Ñ
SettleForRoundResponseH
player_data (2'.xsdq.SettleForRoundResponse.PlayerDataR
playerData
round (Rround

has_settle (R	hasSettle+
bury_bottom (2
.xsdq.CardR
buryBottom!
is_surrender (RisSurrenderö

PlayerData
player (	Rplayer
seat (Rseat
score (Rscore
total (Rtotal
team (Rteam
level (Rlevel
rebel_total (R
rebelTotal#
buckle_points (RbucklePoints#
pickup_points	 (RpickupPoints
team_points
 (R
teamPoints"*
SpeakerRequest
content (	Rcontent"C
SpeakerResponse
player (	Rplayer
content (	Rcontent"o
SponsorVoteResponse
room_id (RroomId
sponsor (	Rsponsor%
expire_seconds (RexpireSeconds"å
StartRoomWebResponse
code (Rcode
room_id (RroomId
app_id (RappId
game_id (RgameId
club_id (RclubId":
SynchroniseCardsResponse
card (2
.xsdq.CardRcard""
TingResponse
seat (Rseat"&
RobotRequest
status (Rstatus"9
RobotResponse
uid (	Ruid
status (Rstatus"2
TableStatusQueryRequest
room_id (RroomId"é
TableStatusQueryResponse
code (Rcode=
player (2%.xsdq.TableStatusQueryResponse.PlayerRplayer
room_id (RroomId
round (Rroundp
Player
aid (Raid
nick (	Rnick
icon (	Ricon
online (Ronline
score (Rscore"=
PushMessageResponse
type (Rtype
text (	Rtext"@
DrawResponse
uid (	Ruid
card (2
.xsdq.CardRcard"R
LordNoticeResponse
uid (	Ruid
timer (Rtimer
value (Rvalue"#
LordRequest
color (Rcolor"J
LordResponse
code (Rcode
uid (	Ruid
color (Rcolor")
KickOffResponse
reason (Rreason"ò
RoundUpdateWebRequest
code (Rcode
room_id (RroomId
app_id (RappId
game_id (RgameId
club_id (RclubId
round_id (RroundId<
players (2".xsdq.RoundUpdateWebRequest.PlayerRplayers0
Player
uid (	Ruid
score (Rscore"ù
RoundUpdateWebResponse
code (Rcode=
players (2#.xsdq.RoundUpdateWebResponse.PlayerRplayers0
Player
uid (	Ruid
score (Rscore"S
RebelNoticeResponse
color (Rcolor
uid (	Ruid
timer (Rtimer"$
RebelRequest
color (Rcolor"K
RebelResponse
code (Rcode
uid (	Ruid
color (Rcolor"S
BCNoticeResponse
uid (	Ruid-
bottom_cards (2
.xsdq.CardRbottomCards"D
ChangeBottomRequest-
bottom_cards (2
.xsdq.CardRbottomCards"k
ChangeBottomResponse
code (Rcode
uid (	Ruid-
bottom_cards (2
.xsdq.CardRbottomCards"+
PointChangeResponse
point (Rpoint"=
PickupPointResponse
uid (	Ruid
point (Rpoint"8
MingjiResponse
uid (	Ruid
teams (	Rteams"
SurrenderRequest"'
SurrenderResponse
code (Rcode"V
ShowLordCardResponse
friend_card (R
friendCard

lord_color (R	lordColor"D
StepStartResponse
code (Rcode
	bury_seat (RburySeat"
CheckBuryCardsRequest"[
CheckBuryCardsResponse
code (Rcode-
bottom_cards (2
.xsdq.CardRbottomCards"Q
	CheckCard
seat (Rseat
uid (	Ruid
card (2
.xsdq.CardRcard"
CheckScoreCardsRequest"_
CheckScoreCardsResponse
code (Rcode0
check_cards (2.xsdq.CheckCardR
checkCards"
CheckPrevCardsRequest"^
CheckPrevCardsResponse
code (Rcode0
check_cards (2.xsdq.CheckCardR
checkCardsbproto3