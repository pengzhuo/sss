
�C
proto/game.protoxsdq"�
Player
seat (
player (	Rplayer
info (	Rinfo
status (
	is_online (
total_score (
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
dice1 (
dice2 (
Prompt
	action_id (
prompt (
ref_card (2
.xsdq.CardRrefCard#
op_card (2
.xsdq.CardRopCard"\
CardTip
card (2
.xsdq.CardRcard
points (Rpoints
rest_cnt (RrestCnt"�
CreateRoomRequest
room_id (
owner (	Rowner
kwargs (	Rkwargs
	room_uuid (	RroomUuid
club_id (RclubId

owner_info (	R	ownerInfo"(
CreateRoomResponse
code (
DealResponse
dealer_uuid (	R
dealerUuid
dice (2
.xsdq.DiceRdice.

.xsdq.CardRcardsInHand#

DiscardTipsResponse
seat (
timer (
	new_round (RnewRound%
show_surrender (R
DiscardRequest
meld (2
.xsdq.MeldRmeld"Y
DiscardResponse
uid (	Ruid
meld (2
.xsdq.MeldRmeld
first (Rfirst"�
DismissRoomWebRequest
room_id (
	game_type (
app_id (
owner (	Rowner
	room_uuid (	RroomUuid"�
DismissRoomWebResponse
code (
room_id (
	game_type (
app_id (
owner (	Rowner"
DismissRoomRequest"�
DismissRoomResponse
code (
flag (
sponsor_type (

decline_players (	RdeclinePlayers

has_settle (
EnterRoomOtherResponse
code (
player (	Rplayer
seat (
info (	Rinfo
score (Rscore"�
EnterRoomWebResponse
code (
room_id (
player (	Rplayer
	game_type (
app_id (
club_id (
EnterRoomRequest
room_id (
player (	Rplayer
info (	Rinfo"�
EnterRoomResponse
code (
room_id (
owner (	Rowner
kwargs (	Rkwargs

rest_cards (
player (2.xsdq.PlayerRplayer

owner_info (	R	ownerInfo
	room_uuid (	RroomUuid".
ExistRoomWebRequest
room_id (
ExistRoomWebResponse
flag (Rflag"�
ExitRoomWebResponse
code (
room_id (
player (	Rplayer
	game_type (
app_id (
club_id (
ExitRoomRequest"R
ExitRoomResponse
code (
player (	Rplayer
flag (
HeartbeatRequest"
HeartbeatResponse"F
OnlineStatusResponse
player (	Rplayer
status (Rstatus""
PassResponse
seat (
PlayerVoteRequest
flag (Rflag"c
PlayerVoteResponse
flag (Rflag
player (	Rplayer!
sponsor_type (
ReadyRequest"'

player (	Rplayer"�	
ReconnectResponse
code (
room_id (
	room_uuid (	RroomUuid
kwargs (	Rkwargs

owner_uuid (	R	ownerUuid

owner_info (	R	ownerInfo
room_status (
roomStatus#


dealer_seat
 (R
dealerSeat
active_seat (R
activeSeat
max_seat (
timer
player (2.xsdq.ReconnectResponse.PlayerRplayer-
bottom_cards (2
.xsdq.CardRbottomCards!
master_color (
master_seat (
masterSeat!
friend_color (
change_seat (
changeSeat
mingji (Rmingji
teams (	Rteams
table_score (
tableScore%
show_surrender (R

first_seat (R	firstSeat
	bury_seat (

rebel_seat (
Player
seat (
player (	Rplayer
info (	Rinfo
status (
	is_online (
round_score (R
roundScore
total_score (R
totalScore.

.xsdq.CardRcardsInHand$
discard	 (2
.xsdq.MeldRdiscard
robot
 (Rrobot
point (Rpoint
	rob_color (RrobColor"�
RefundWebResponse
code (
room_id (
	game_type (
app_id (
owner (	Rowner
	room_uuid (	RroomUuid"�
RunningWebResponse
sessions (
players (
tables_initial (
tables_playing (

player (2.xsdq.ScoreResponse.PlayerRplayer2
Player
seat (
score (Rscore"�
SettleForRoomResponse
flag (
player_data (2&.xsdq.SettleForRoomResponse.PlayerDataR
playerData�

PlayerData
player (	Rplayer
seat (
total_score (R
totalScore
	top_score (RtopScore
win_cnt (
lose_cnt (
	top_level (
is_owner (
status	 (
SettleForRoundResponseH
player_data (2'.xsdq.SettleForRoundResponse.PlayerDataR
playerData
round (Rround

has_settle (
bury_bottom (2
.xsdq.CardR
buryBottom!
is_surrender (RisSurrender�

PlayerData
player (	Rplayer
seat (
score (Rscore
total (Rtotal
team (Rteam
level (
rebel_total (
rebelTotal#


team_points
 (
teamPoints"*
SpeakerRequest
content (	Rcontent"C
SpeakerResponse
player (	Rplayer
content (	Rcontent"o
SponsorVoteResponse
room_id (
sponsor (	Rsponsor%
expire_seconds (
StartRoomWebResponse
code (
room_id (
app_id (
game_id (
club_id (
SynchroniseCardsResponse
card (2
.xsdq.CardRcard""
TingResponse
seat (
RobotRequest
status (Rstatus"9

uid (	Ruid
status (Rstatus"2
TableStatusQueryRequest
room_id (RroomId"�
TableStatusQueryResponse
code (Rcode=
player (2%.xsdq.TableStatusQueryResponse.PlayerRplayer
room_id (
round (
Player
aid (Raid
nick (	Rnick
icon (	Ricon
online (Ronline
score (Rscore"=
PushMessageResponse
type (
text (	Rtext"@
DrawResponse
uid (	Ruid
card (2
.xsdq.CardRcard"R
LordNoticeResponse
uid (	Ruid
timer (
value (
LordRequest
color (
LordResponse
code (
uid (	Ruid
color (
KickOffResponse
reason (
RoundUpdateWebRequest
code (
room_id (
app_id (
game_id (
club_id (
round_id (
players (2".xsdq.RoundUpdateWebRequest.PlayerRplayers0
Player
uid (	Ruid
score (Rscore"�
RoundUpdateWebResponse
code (
players (2#.xsdq.RoundUpdateWebResponse.PlayerRplayers0
Player
uid (	Ruid
score (Rscore"S
RebelNoticeResponse
color (
uid (	Ruid
timer (
RebelRequest
color (

code (
uid (	Ruid
color (
BCNoticeResponse
uid (	Ruid-
bottom_cards (2
.xsdq.CardRbottomCards"D
ChangeBottomRequest-
bottom_cards (2
.xsdq.CardRbottomCards"k
ChangeBottomResponse
code (
uid (	Ruid-
bottom_cards (2
.xsdq.CardRbottomCards"+
PointChangeResponse
point (
PickupPointResponse
uid (	Ruid
point (
MingjiResponse
uid (	Ruid
teams (	Rteams"
SurrenderRequest"'
SurrenderResponse
code (
ShowLordCardResponse
friend_card (
friendCard

lord_color (
StepStartResponse
code (
	bury_seat (
CheckBuryCardsRequest"[
CheckBuryCardsResponse
code (
bottom_cards (2
.xsdq.CardRbottomCards"Q
	CheckCard
seat (
uid (	Ruid
card (2
.xsdq.CardRcard"
CheckScoreCardsRequest"_
CheckScoreCardsResponse
code (
check_cards (2.xsdq.CheckCardR
checkCards"
CheckPrevCardsRequest"^
CheckPrevCardsResponse
code (
check_cards (2.xsdq.CheckCardR
checkCardsbproto3