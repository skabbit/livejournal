#
# database schema & data info
#

mark_clustered(@LJ::USER_TABLES);

register_tablecreate("adopt", <<'EOC');
CREATE TABLE adopt (
  adoptid int(10) unsigned NOT NULL auto_increment,
  helperid int(10) unsigned NOT NULL default '0',
  newbieid int(10) unsigned NOT NULL default '0',
  changetime datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (adoptid),
  KEY (helperid),
  KEY (newbieid)
)
EOC

register_tablecreate("adoptlast", <<'EOC');
CREATE TABLE adoptlast (
  userid int(10) unsigned NOT NULL default '0',
  lastassigned datetime NOT NULL default '0000-00-00 00:00:00',
  lastadopted datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (userid)
)
EOC

register_tablecreate("authactions", <<'EOC');
CREATE TABLE authactions (
  aaid int(10) unsigned NOT NULL auto_increment,
  userid int(10) unsigned NOT NULL default '0',
  datecreate datetime NOT NULL default '0000-00-00 00:00:00',
  authcode varchar(20) default NULL,
  action varchar(50) default NULL,
  arg1 varchar(255) default NULL,
  PRIMARY KEY  (aaid)
)
EOC

register_tablecreate("birthdays", <<'EOC');
CREATE TABLE birthdays (
  userid INT UNSIGNED NOT NULL,
  nextbirthday INT UNSIGNED,
  PRIMARY KEY (userid),
  KEY (nextbirthday)
)
EOC

register_tablecreate("clients", <<'EOC');
CREATE TABLE clients (
  clientid smallint(5) unsigned NOT NULL auto_increment,
  client varchar(40) default NULL,
  PRIMARY KEY  (clientid),
  KEY (client)
)
EOC

post_create("clients",
            "sqltry" => "INSERT INTO clients (client) SELECT DISTINCT client FROM logins",
            );

register_tablecreate("clientusage", <<'EOC');
CREATE TABLE clientusage (
  userid int(10) unsigned NOT NULL default '0',
  clientid smallint(5) unsigned NOT NULL default '0',
  lastlogin datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (clientid,userid),
  UNIQUE KEY userid (userid,clientid)
)
EOC

post_create("clientusage",
            "sqltry" => "INSERT INTO clientusage SELECT u.userid, c.clientid, l.lastlogin FROM user u, clients c, logins l WHERE u.user=l.user AND l.client=c.client",
            );

register_tablecreate("codes", <<'EOC');
CREATE TABLE codes (
  type varchar(10) NOT NULL default '',
  code varchar(7) NOT NULL default '',
  item varchar(80) default NULL,
  sortorder smallint(6) NOT NULL default '0',
  PRIMARY KEY  (type,code)
) PACK_KEYS=1
EOC

register_tablecreate("community", <<'EOC');
CREATE TABLE community (
  userid int(10) unsigned NOT NULL default '0',
  ownerid int(10) unsigned NOT NULL default '0',
  membership enum('open','closed') NOT NULL default 'open',
  postlevel enum('members','select','screened') default NULL,
  PRIMARY KEY  (userid)
)
EOC

register_tablecreate("dirsearchres2", <<'EOC');
CREATE TABLE dirsearchres2 (
  qdigest varchar(32) NOT NULL default '',
  dateins datetime NOT NULL default '0000-00-00 00:00:00',
  userids blob,
  PRIMARY KEY  (qdigest),
  KEY (dateins)
)
EOC

register_tablecreate("duplock", <<'EOC');
CREATE TABLE duplock (
  realm enum('support','log','comment') NOT NULL default 'support',
  reid int(10) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  digest char(32) NOT NULL default '',
  dupid int(10) unsigned NOT NULL default '0',
  instime datetime NOT NULL default '0000-00-00 00:00:00',
  KEY (realm,reid,userid)
)
EOC

register_tablecreate("faq", <<'EOC');
CREATE TABLE faq (
  faqid mediumint(8) unsigned NOT NULL auto_increment,
  question text,
  answer text,
  sortorder int(11) default NULL,
  faqcat varchar(20) default NULL,
  uses int(11) NOT NULL default '0',
  lastmodtime datetime default NULL,
  lastmoduserid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (faqid)
)
EOC

register_tablecreate("faqcat", <<'EOC');
CREATE TABLE faqcat (
  faqcat varchar(20) NOT NULL default '',
  faqcatname varchar(100) default NULL,
  catorder int(11) default '50',
  PRIMARY KEY  (faqcat)
)
EOC

register_tablecreate("faquses", <<'EOC');
CREATE TABLE faquses (
  faqid MEDIUMINT UNSIGNED NOT NULL,
  userid INT UNSIGNED NOT NULL,
  dateview DATETIME NOT NULL,
  PRIMARY KEY (userid, faqid),
  KEY (faqid),
  KEY (dateview)
)
EOC

register_tablecreate("friendgroup", <<'EOC');
CREATE TABLE friendgroup (
  userid int(10) unsigned NOT NULL default '0',
  groupnum tinyint(3) unsigned NOT NULL default '0',
  groupname varchar(30) NOT NULL default '',
  sortorder tinyint(3) unsigned NOT NULL default '50',
  is_public enum('0','1') NOT NULL default '0',
  PRIMARY KEY  (userid,groupnum)
)
EOC

register_tablecreate("friends", <<'EOC');
CREATE TABLE friends (
  userid int(10) unsigned NOT NULL default '0',
  friendid int(10) unsigned NOT NULL default '0',
  fgcolor char(7) default NULL,
  bgcolor char(7) default NULL,
  groupmask int(10) unsigned NOT NULL default '1',
  showbydefault enum('1','0') NOT NULL default '1',
  PRIMARY KEY  (userid,friendid),
  KEY (friendid)
)
EOC

register_tablecreate("interests", <<'EOC');
CREATE TABLE interests (
  intid int(10) unsigned NOT NULL auto_increment,
  interest varchar(255) NOT NULL default '',
  intcount mediumint(8) unsigned default NULL,
  PRIMARY KEY  (intid),
  UNIQUE interest (interest)
)
EOC

register_tablecreate("keywords", <<'EOC');
CREATE TABLE keywords (
  kwid int(10) unsigned NOT NULL auto_increment,
  keyword varchar(80) binary NOT NULL default '',
  PRIMARY KEY  (kwid),
  UNIQUE KEY kwidx (keyword)
)
EOC

register_tablecreate("logproplist", <<'EOC');
CREATE TABLE logproplist (
  propid tinyint(3) unsigned NOT NULL auto_increment,
  name varchar(50) default NULL,
  prettyname varchar(60) default NULL,
  sortorder mediumint(8) unsigned default NULL,
  datatype enum('char','num','bool') NOT NULL default 'char',
  des varchar(255) default NULL,
  PRIMARY KEY  (propid),
  UNIQUE KEY name (name)
)
EOC

register_tablecreate("memkeyword", <<'EOC');
CREATE TABLE memkeyword (
  memid int(10) unsigned NOT NULL default '0',
  kwid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (memid,kwid)
)
EOC

register_tablecreate("memorable", <<'EOC');
CREATE TABLE memorable (
  memid int(10) unsigned NOT NULL auto_increment,
  userid int(10) unsigned NOT NULL default '0',
  itemid int(10) unsigned NOT NULL default '0',
  des varchar(60) default NULL,
  security enum('public','friends','private') NOT NULL default 'public',
  PRIMARY KEY  (memid),
  UNIQUE KEY userid (userid,itemid),
  KEY (itemid)
)
EOC

register_tablecreate("moods", <<'EOC');
CREATE TABLE moods (
  moodid int(10) unsigned NOT NULL auto_increment,
  mood varchar(40) default NULL,
  parentmood int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (moodid),
  UNIQUE KEY mood (mood)
)
EOC

register_tablecreate("moodthemedata", <<'EOC');
CREATE TABLE moodthemedata (
  moodthemeid int(10) unsigned NOT NULL default '0',
  moodid int(10) unsigned NOT NULL default '0',
  picurl varchar(100) default NULL,
  width tinyint(3) unsigned NOT NULL default '0',
  height tinyint(3) unsigned NOT NULL default '0',
  KEY (moodthemeid),
  PRIMARY KEY  (moodthemeid,moodid)
)
EOC

register_tablecreate("moodthemes", <<'EOC');
CREATE TABLE moodthemes (
  moodthemeid int(10) unsigned NOT NULL auto_increment,
  ownerid int(10) unsigned NOT NULL default '0',
  name varchar(50) default NULL,
  des varchar(100) default NULL,
  is_public enum('Y','N') NOT NULL default 'N',
  PRIMARY KEY  (moodthemeid),
  KEY (is_public),
  KEY (ownerid)
)
EOC

register_tablecreate("news_sent", <<'EOC');
CREATE TABLE news_sent (
  newsid int(10) unsigned NOT NULL auto_increment,
  newsnum mediumint(8) unsigned NOT NULL default '0',
  user varchar(15) NOT NULL default '',
  datesent datetime default NULL,
  email varchar(100) NOT NULL default '',
  PRIMARY KEY  (newsid),
  KEY (newsnum),
  KEY (user),
  KEY (email)
)
EOC

register_tablecreate("noderefs", <<'EOC');
CREATE TABLE noderefs (
  nodetype char(1) NOT NULL default '',
  nodeid int(10) unsigned NOT NULL default '0',
  urlmd5 varchar(32) NOT NULL default '',
  url varchar(120) NOT NULL default '',
  PRIMARY KEY  (nodetype,nodeid,urlmd5)
)
EOC

register_tablecreate("overrides", <<'EOC'); # global, old
CREATE TABLE overrides (
  user varchar(15) NOT NULL default '',
  override text,
  PRIMARY KEY  (user)
)
EOC

register_tablecreate("pendcomments", <<'EOC');
CREATE TABLE pendcomments (
  jid int(10) unsigned NOT NULL,
  pendcid int(10) unsigned NOT NULL,
  data blob NOT NULL,
  datesubmit int(10) unsigned NOT NULL,
  PRIMARY KEY (pendcid, jid),
  KEY (datesubmit)
)
EOC

register_tablecreate("poll", <<'EOC');
CREATE TABLE poll (
  pollid int(10) unsigned NOT NULL auto_increment,
  itemid int(10) unsigned NOT NULL default '0',
  journalid int(10) unsigned NOT NULL default '0',
  posterid int(10) unsigned NOT NULL default '0',
  whovote enum('all','friends') NOT NULL default 'all',
  whoview enum('all','friends','none') NOT NULL default 'all',
  name varchar(255) default NULL,
  PRIMARY KEY  (pollid),
  KEY (itemid),
  KEY (journalid),
  KEY (posterid)
)
EOC

register_tablecreate("pollitem", <<'EOC');
CREATE TABLE pollitem (
  pollid int(10) unsigned NOT NULL default '0',
  pollqid tinyint(3) unsigned NOT NULL default '0',
  pollitid tinyint(3) unsigned NOT NULL default '0',
  sortorder tinyint(3) unsigned NOT NULL default '0',
  item varchar(255) default NULL,
  PRIMARY KEY  (pollid,pollqid,pollitid)
)
EOC

register_tablecreate("pollquestion", <<'EOC');
CREATE TABLE pollquestion (
  pollid int(10) unsigned NOT NULL default '0',
  pollqid tinyint(3) unsigned NOT NULL default '0',
  sortorder tinyint(3) unsigned NOT NULL default '0',
  type enum('check','radio','drop','text','scale') default NULL,
  opts varchar(20) default NULL,
  qtext text,
  PRIMARY KEY  (pollid,pollqid)
)
EOC

register_tablecreate("pollresult", <<'EOC');
CREATE TABLE pollresult (
  pollid int(10) unsigned NOT NULL default '0',
  pollqid tinyint(3) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  value varchar(255) default NULL,
  PRIMARY KEY  (pollid,pollqid,userid),
  KEY (pollid,userid)
)
EOC

register_tablecreate("pollsubmission", <<'EOC');
CREATE TABLE pollsubmission (
  pollid int(10) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  datesubmit datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (pollid,userid),
  KEY (userid)
)
EOC

register_tablecreate("priv_list", <<'EOC');
CREATE TABLE priv_list (
  prlid smallint(5) unsigned NOT NULL auto_increment,
  privcode varchar(20) NOT NULL default '',
  privname varchar(40) default NULL,
  des varchar(255) default NULL,
  is_public ENUM('1', '0') DEFAULT '1' NOT NULL,
  PRIMARY KEY  (prlid),
  UNIQUE KEY privcode (privcode)
)
EOC

register_tablecreate("priv_map", <<'EOC');
CREATE TABLE priv_map (
  prmid mediumint(8) unsigned NOT NULL auto_increment,
  userid int(10) unsigned NOT NULL default '0',
  prlid smallint(5) unsigned NOT NULL default '0',
  arg varchar(40) default NULL,
  PRIMARY KEY  (prmid),
  KEY (userid),
  KEY (prlid)
)
EOC

register_tablecreate("cmdbuffer", <<'EOC');
CREATE TABLE cmdbuffer (
  cbid INT UNSIGNED NOT NULL AUTO_INCREMENT,
  journalid INT UNSIGNED NOT NULL,
  cmd VARCHAR(30) NOT NULL default '',
  instime datetime NOT NULL default '0000-00-00 00:00:00',
  args TEXT NOT NULL,
  PRIMARY KEY  (cbid),
  KEY (cmd),
  KEY (journalid)
)
EOC

register_tablecreate("random_user_set", <<'EOC');
CREATE TABLE random_user_set (
  posttime INT UNSIGNED NOT NULL,
  userid INT UNSIGNED NOT NULL,
  PRIMARY KEY (posttime)
)
EOC

register_tablecreate("schemacols", <<'EOC');
CREATE TABLE schemacols (
  tablename varchar(40) NOT NULL default '',
  colname varchar(40) NOT NULL default '',
  des varchar(255) default NULL,
  PRIMARY KEY  (tablename,colname)
)
EOC

register_tablecreate("schematables", <<'EOC');
CREATE TABLE schematables (
  tablename varchar(40) NOT NULL default '',
  public_browsable enum('0','1') NOT NULL default '0',
  redist_mode enum('off','insert','replace') NOT NULL default 'off',
  des text,
  PRIMARY KEY  (tablename)
)
EOC

register_tablecreate("stats", <<'EOC');
CREATE TABLE stats (
  statcat varchar(30) NOT NULL,
  statkey varchar(150) NOT NULL,
  statval int(10) unsigned NOT NULL,
  UNIQUE KEY statcat_2 (statcat,statkey)
)
EOC

register_tablecreate("blobcache", <<'EOC');
CREATE TABLE blobcache (
  bckey VARCHAR(40) NOT NULL,
  PRIMARY KEY (bckey),
  dateupdate  DATETIME,
  value    MEDIUMBLOB
)
EOC

register_tablecreate("style", <<'EOC');
CREATE TABLE style (
  styleid int(11) NOT NULL auto_increment,
  user varchar(15) NOT NULL default '',
  styledes varchar(50) default NULL,
  type varchar(10) NOT NULL default '',
  formatdata text,
  is_public enum('Y','N') NOT NULL default 'N',
  is_embedded enum('Y','N') NOT NULL default 'N',
  is_colorfree enum('Y','N') NOT NULL default 'N',
  opt_cache enum('Y','N') NOT NULL default 'N',
  has_ads enum('Y','N') NOT NULL default 'N',
  lastupdate datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (styleid),
  KEY (user),
  KEY (type)
)  PACK_KEYS=1
EOC

# cache Storable-frozen pre-cleaned style variables
register_tablecreate("s1stylecache", <<'EOC'); # clustered
CREATE TABLE s1stylecache (
   styleid   INT UNSIGNED NOT NULL PRIMARY KEY,
   cleandate     DATETIME,
   type          VARCHAR(10) NOT NULL DEFAULT '',
   opt_cache     ENUM('Y','N') NOT NULL DEFAULT 'N',
   vars_stor     BLOB,
   vars_cleanver SMALLINT UNSIGNED NOT NULL
)
EOC

# caches Storable-frozen pre-cleaned overrides & colors
register_tablecreate("s1usercache", <<'EOC'); # clustered
CREATE TABLE s1usercache (
   userid            INT UNSIGNED NOT NULL PRIMARY KEY,
   override_stor     BLOB,
   override_cleanver SMALLINT UNSIGNED NOT NULL,
   color_stor        BLOB
)
EOC

register_tablecreate("support", <<'EOC');
CREATE TABLE support (
  spid int(10) unsigned NOT NULL auto_increment,
  reqtype enum('user','email') default NULL,
  requserid int(10) unsigned NOT NULL default '0',
  reqname varchar(50) default NULL,
  reqemail varchar(70) default NULL,
  state enum('open','closed') default NULL,
  authcode varchar(15) NOT NULL default '',
  spcatid int(10) unsigned NOT NULL default '0',
  subject varchar(80) default NULL,
  timecreate int(10) unsigned default NULL,
  timetouched int(10) unsigned default NULL,
  timeclosed int(10) unsigned default NULL,
  PRIMARY KEY  (spid),
  INDEX (state),
  INDEX (requserid),
  INDEX (reqemail)
)
EOC

register_tablecreate("supportcat", <<'EOC');
CREATE TABLE supportcat (
  spcatid int(10) unsigned NOT NULL auto_increment,
  catname varchar(80) default NULL,
  sortorder mediumint(8) unsigned NOT NULL default '0',
  basepoints tinyint(3) unsigned NOT NULL default '1',
  PRIMARY KEY  (spcatid)
)
EOC

register_tablecreate("supportlog", <<'EOC');
CREATE TABLE supportlog (
  splid int(10) unsigned NOT NULL auto_increment,
  spid int(10) unsigned NOT NULL default '0',
  timelogged int(10) unsigned NOT NULL default '0',
  type enum('req','custom','faqref') default NULL,
  faqid mediumint(8) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  message text,
  PRIMARY KEY  (splid),
  KEY (spid)
)
EOC

register_tablecreate("supportnotify", <<'EOC');
CREATE TABLE supportnotify (
  spcatid int(10) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  level enum('all','new') default NULL,
  KEY (spcatid),
  KEY (userid),
  PRIMARY KEY  (spcatid,userid)
)
EOC

register_tablecreate("supportpoints", <<'EOC');
CREATE TABLE supportpoints (
  spid int(10) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  points tinyint(3) unsigned default NULL,
  KEY (spid),
  KEY (userid)
)
EOC

register_tablecreate("supportpointsum", <<'EOC');
CREATE TABLE supportpointsum (
  userid INT UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (userid),
  totpoints MEDIUMINT UNSIGNED DEFAULT 0,
  lastupdate  INT UNSIGNED NOT NULL,
  INDEX (totpoints, lastupdate),
  INDEX (lastupdate)
)
EOC

post_create("supportpointsum",
            "sqltry" => "INSERT IGNORE INTO supportpointsum (userid, totpoints, lastupdate) " .
            "SELECT userid, SUM(points), 0 FROM supportpoints GROUP BY userid",
            );


register_tablecreate("talkproplist", <<'EOC');
CREATE TABLE talkproplist (
  tpropid smallint(5) unsigned NOT NULL auto_increment,
  name varchar(50) default NULL,
  prettyname varchar(60) default NULL,
  datatype enum('char','num','bool') NOT NULL default 'char',
  des varchar(255) default NULL,
  PRIMARY KEY  (tpropid),
  UNIQUE KEY name (name)
)
EOC

register_tablecreate("themedata", <<'EOC');
CREATE TABLE themedata (
  themeid mediumint(8) unsigned NOT NULL default '0',
  coltype varchar(30) default NULL,
  color varchar(30) default NULL,
  KEY (themeid)
) PACK_KEYS=1
EOC

register_tablecreate("themelist", <<'EOC');
CREATE TABLE themelist (
  themeid mediumint(8) unsigned NOT NULL auto_increment,
  name varchar(50) NOT NULL default '',
  PRIMARY KEY  (themeid)
)
EOC

register_tablecreate("todo", <<'EOC');
CREATE TABLE todo (
  todoid int(10) unsigned NOT NULL auto_increment,
  journalid int(10) unsigned NOT NULL default '0',
  posterid int(10) unsigned NOT NULL default '0',
  ownerid int(10) unsigned NOT NULL default '0',
  statusline varchar(40) default NULL,
  security enum('public','private','friends') NOT NULL default 'public',
  subject varchar(100) default NULL,
  des varchar(255) default NULL,
  priority enum('1','2','3','4','5') NOT NULL default '3',
  datecreate datetime NOT NULL default '0000-00-00 00:00:00',
  dateupdate datetime default NULL,
  datedue datetime default NULL,
  dateclosed datetime default NULL,
  progress tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY  (todoid),
  KEY (journalid),
  KEY (posterid),
  KEY (ownerid)
)
EOC

register_tablecreate("tododep", <<'EOC');
CREATE TABLE tododep (
  todoid int(10) unsigned NOT NULL default '0',
  depid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (todoid,depid),
  KEY (depid)
)
EOC

register_tablecreate("todokeyword", <<'EOC');
CREATE TABLE todokeyword (
  todoid int(10) unsigned NOT NULL default '0',
  kwid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (todoid,kwid)
)
EOC

register_tablecreate("txtmsg", <<'EOC');
CREATE TABLE txtmsg (
  userid int(10) unsigned NOT NULL default '0',
  provider varchar(25) default NULL,
  number varchar(60) default NULL,
  security enum('all','reg','friends') NOT NULL default 'all',
  PRIMARY KEY  (userid)
)
EOC

register_tablecreate("user", <<'EOC');
CREATE TABLE user (
  userid int(10) unsigned NOT NULL auto_increment,
  user char(15) default NULL,
  caps SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  email char(50) default NULL,
  password char(30) default NULL,
  status char(1) NOT NULL default 'N',
  statusvis char(1) NOT NULL default 'V',
  statusvisdate datetime default NULL,
  name char(50) default NULL,
  bdate date default NULL,
  themeid int(11) NOT NULL default '1',
  moodthemeid int(10) unsigned NOT NULL default '1',
  opt_forcemoodtheme enum('Y','N') NOT NULL default 'N',
  allow_infoshow char(1) NOT NULL default 'Y',
  allow_contactshow char(1) NOT NULL default 'Y',
  allow_getljnews char(1) NOT NULL default 'N',
  opt_showtalklinks char(1) NOT NULL default 'Y',
  opt_whocanreply enum('all','reg','friends') NOT NULL default 'all',
  opt_gettalkemail char(1) NOT NULL default 'Y',
  opt_htmlemail enum('Y','N') NOT NULL default 'Y',
  opt_mangleemail char(1) NOT NULL default 'N',
  useoverrides char(1) NOT NULL default 'N',
  defaultpicid int(10) unsigned default NULL,
  has_bio enum('Y','N') NOT NULL default 'N',
  txtmsg_status enum('none','on','off') NOT NULL default 'none',
  is_system enum('Y','N') NOT NULL default 'N',
  journaltype char(1) NOT NULL default 'P',
  lang char(2) NOT NULL default 'EN',
  PRIMARY KEY  (userid),
  UNIQUE KEY user (user),
  KEY (email),
  KEY (status),
  KEY (statusvis)
)  PACK_KEYS=1
EOC

register_tablecreate("userbio", <<'EOC');
CREATE TABLE userbio (
  userid int(10) unsigned NOT NULL default '0',
  bio text,
  PRIMARY KEY  (userid)
)
EOC

register_tablecreate("userinterests", <<'EOC');
CREATE TABLE userinterests (
  userid int(10) unsigned NOT NULL default '0',
  intid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (userid,intid),
  KEY (intid)
)
EOC

register_tablecreate("userpic", <<'EOC');
CREATE TABLE userpic (
  picid int(10) unsigned NOT NULL auto_increment,
  userid int(10) unsigned NOT NULL default '0',
  contenttype char(25) default NULL,
  width smallint(6) NOT NULL default '0',
  height smallint(6) NOT NULL default '0',
  state char(1) NOT NULL default 'N',
  picdate datetime default NULL,
  md5base64 char(22) NOT NULL default '',
  PRIMARY KEY  (picid),
  KEY (userid),
  KEY (state)
)
EOC

register_tablecreate("userpicblob2", <<'EOC');
CREATE TABLE userpicblob2 (
  userid int unsigned not null,
  picid int unsigned not null,
  imagedata blob,
  PRIMARY KEY (userid, picid)
) max_rows=10000000
EOC

register_tablecreate("userpicmap", <<'EOC');
CREATE TABLE userpicmap (
  userid int(10) unsigned NOT NULL default '0',
  kwid int(10) unsigned NOT NULL default '0',
  picid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (userid,kwid)
)
EOC

register_tablecreate("userpicmap2", <<'EOC');
CREATE TABLE userpicmap2 (
  userid int(10) unsigned NOT NULL default '0',
  kwid int(10) unsigned NOT NULL default '0',
  picid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (userid, kwid)
)
EOC

register_tablecreate("userpic2", <<'EOC');
CREATE TABLE userpic2 (
  picid int(10) unsigned NOT NULL,
  userid int(10) unsigned NOT NULL default '0',
  fmt char(1) default NULL,
  width smallint(6) NOT NULL default '0',
  height smallint(6) NOT NULL default '0',
  state char(1) NOT NULL default 'N',
  picdate datetime default NULL,
  md5base64 char(22) NOT NULL default '',
  comment varchar(255) BINARY NOT NULL default '',
  flags tinyint(1) unsigned NOT NULL default 0,
  location enum('blob','disk','mogile') default NULL,
  PRIMARY KEY  (userid, picid)
)
EOC

# - blobids aren't necessarily unique between domains;
# global userpicids may collide with the counter used for the rest.
# so type must be in the key.
# - domain ids are set up in ljconfig.pl.
# - NULL length indicates the data is external-- we need another
# table for more data for that.
register_tablecreate("userblob", <<'EOC'); # clustered
CREATE TABLE userblob (
  journalid   INT       UNSIGNED NOT NULL,
  domain      TINYINT   UNSIGNED NOT NULL,
  blobid      MEDIUMINT UNSIGNED NOT NULL,
  length      MEDIUMINT UNSIGNED,
  PRIMARY KEY (journalid, domain, blobid),
  KEY (domain)
)
EOC

register_tablecreate("userproplist", <<'EOC');
CREATE TABLE userproplist (
  upropid smallint(5) unsigned NOT NULL auto_increment,
  name varchar(50) default NULL,
  indexed enum('1','0') NOT NULL default '1',
  prettyname varchar(60) default NULL,
  datatype enum('char','num','bool') NOT NULL default 'char',
  des varchar(255) default NULL,
  PRIMARY KEY  (upropid),
  UNIQUE KEY name (name)
)
EOC

# global, indexed
register_tablecreate("userprop", <<'EOC');
CREATE TABLE userprop (
  userid int(10) unsigned NOT NULL default '0',
  upropid smallint(5) unsigned NOT NULL default '0',
  value varchar(60) default NULL,
  PRIMARY KEY  (userid,upropid),
  KEY (upropid,value)
)
EOC

# global, not indexed
register_tablecreate("userproplite", <<'EOC');
CREATE TABLE userproplite (
  userid int(10) unsigned NOT NULL default '0',
  upropid smallint(5) unsigned NOT NULL default '0',
  value varchar(255) default NULL,
  PRIMARY KEY  (userid,upropid),
  KEY (upropid)
)
EOC

# clustered, not indexed
register_tablecreate("userproplite2", <<'EOC');
CREATE TABLE userproplite2 (
  userid int(10) unsigned NOT NULL default '0',
  upropid smallint(5) unsigned NOT NULL default '0',
  value varchar(255) default NULL,
  PRIMARY KEY  (userid,upropid),
  KEY (upropid)
)
EOC

# clustered
register_tablecreate("userpropblob", <<'EOC');
CREATE TABLE userpropblob (
    userid INT(10) unsigned NOT NULL default '0',
    upropid SMALLINT(5) unsigned NOT NULL default '0',
    value blob,
    PRIMARY KEY (userid,upropid)
)
EOC

register_tablecreate("backupdirty", <<'EOC');
CREATE TABLE backupdirty (
    userid INT(10) unsigned NOT NULL default '0',
    marktime INT(10) unsigned NOT NULL default '0',
    PRIMARY KEY (userid)
)
EOC

register_tablecreate("zip", <<'EOC');
CREATE TABLE zip (
  zip varchar(5) NOT NULL default '',
  state char(2) NOT NULL default '',
  city varchar(100) NOT NULL default '',
  PRIMARY KEY  (zip),
  KEY (state)
) PACK_KEYS=1
EOC

register_tablecreate("zips", <<'EOC');
CREATE TABLE zips (
  FIPS char(2) default NULL,
  zip varchar(5) NOT NULL default '',
  State char(2) NOT NULL default '',
  Name varchar(30) NOT NULL default '',
  alloc float(9,7) NOT NULL default '0.0000000',
  pop1990 int(11) NOT NULL default '0',
  lon float(10,7) NOT NULL default '0.0000000',
  lat float(10,7) NOT NULL default '0.0000000',
  PRIMARY KEY  (zip)
)
EOC

################# above was a snapshot.  now, changes:

register_tablecreate("log2", <<'EOC');
CREATE TABLE log2 (
  journalid INT UNSIGNED NOT NULL default '0',
  jitemid MEDIUMINT UNSIGNED NOT NULL,
  PRIMARY KEY  (journalid, jitemid),
  posterid int(10) unsigned NOT NULL default '0',
  eventtime datetime default NULL,
  logtime datetime default NULL,
  compressed char(1) NOT NULL default 'N',
  anum TINYINT UNSIGNED NOT NULL,
  security enum('public','private','usemask') NOT NULL default 'public',
  allowmask int(10) unsigned NOT NULL default '0',
  replycount smallint(5) unsigned default NULL,
  year smallint(6) NOT NULL default '0',
  month tinyint(4) NOT NULL default '0',
  day tinyint(4) NOT NULL default '0',
  rlogtime int(10) unsigned NOT NULL default '0',
  revttime int(10) unsigned NOT NULL default '0',
  KEY (journalid,year,month,day),
  KEY `rlogtime` (`journalid`,`rlogtime`),
  KEY `revttime` (`journalid`,`revttime`),
  KEY `posterid` (`posterid`,`journalid`)
)
EOC

register_tablecreate("logtext2", <<'EOC');
CREATE TABLE logtext2 (
  journalid INT UNSIGNED NOT NULL,
  jitemid MEDIUMINT UNSIGNED NOT NULL,
  subject VARCHAR(255) DEFAULT NULL,
  event TEXT,
  PRIMARY KEY (journalid, jitemid)
) max_rows=100000000
EOC

register_tablecreate("logprop2", <<'EOC');
CREATE TABLE logprop2 (
  journalid  INT UNSIGNED NOT NULL,
  jitemid MEDIUMINT UNSIGNED NOT NULL,
  propid TINYINT unsigned NOT NULL,
  value VARCHAR(255) default NULL,
  PRIMARY KEY (journalid,jitemid,propid)
)
EOC

register_tablecreate("logsec2", <<'EOC');
CREATE TABLE logsec2 (
  journalid INT UNSIGNED NOT NULL,
  jitemid MEDIUMINT UNSIGNED NOT NULL,
  allowmask INT UNSIGNED NOT NULL,
  PRIMARY KEY (journalid,jitemid)
)
EOC

register_tablecreate("talk2", <<'EOC');
CREATE TABLE talk2 (
  journalid INT UNSIGNED NOT NULL,
  jtalkid INT UNSIGNED NOT NULL,
  nodetype CHAR(1) NOT NULL DEFAULT '',
  nodeid INT UNSIGNED NOT NULL default '0',
  parenttalkid INT UNSIGNED NOT NULL,
  posterid INT UNSIGNED NOT NULL default '0',
  datepost DATETIME NOT NULL default '0000-00-00 00:00:00',
  state CHAR(1) default 'A',
  PRIMARY KEY  (journalid,jtalkid),
  KEY (nodetype,journalid,nodeid),
  KEY (journalid,state,nodetype),
  KEY (posterid)
)
EOC

register_tablecreate("talkprop2", <<'EOC');
CREATE TABLE talkprop2 (
  journalid INT UNSIGNED NOT NULL,
  jtalkid INT UNSIGNED NOT NULL,
  tpropid TINYINT UNSIGNED NOT NULL,
  value VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY  (journalid,jtalkid,tpropid)
)
EOC

register_tablecreate("talktext2", <<'EOC');
CREATE TABLE talktext2 (
  journalid INT UNSIGNED NOT NULL,
  jtalkid INT UNSIGNED NOT NULL,
  subject VARCHAR(100) DEFAULT NULL,
  body TEXT,
  PRIMARY KEY (journalid, jtalkid)
) max_rows=100000000
EOC

register_tablecreate("talkleft", <<'EOC');
CREATE TABLE talkleft (
  userid    INT UNSIGNED NOT NULL,
  posttime  INT UNSIGNED NOT NULL,
  INDEX (userid, posttime),
  journalid  INT UNSIGNED NOT NULL,
  nodetype   CHAR(1) NOT NULL,
  nodeid     INT UNSIGNED NOT NULL,
  INDEX (journalid, nodetype, nodeid),
  jtalkid    INT UNSIGNED NOT NULL,
  publicitem   ENUM('1','0') NOT NULL DEFAULT '1'
)
EOC

register_tablecreate("talkleft_xfp", <<'EOC');
CREATE TABLE talkleft_xfp (
  userid    INT UNSIGNED NOT NULL,
  posttime  INT UNSIGNED NOT NULL,
  INDEX (userid, posttime),
  journalid  INT UNSIGNED NOT NULL,
  nodetype   CHAR(1) NOT NULL,
  nodeid     INT UNSIGNED NOT NULL,
  INDEX (journalid, nodetype, nodeid),
  jtalkid    INT UNSIGNED NOT NULL,
  publicitem   ENUM('1','0') NOT NULL DEFAULT '1'
)
EOC

register_tabledrop("ibill_codes");
register_tabledrop("paycredit");
register_tabledrop("payments");
register_tabledrop("tmp_contributed");
register_tabledrop("transferinfo");
register_tabledrop("contest1");
register_tabledrop("contest1data");
register_tabledrop("logins");
register_tabledrop("hintfriendsview");
register_tabledrop("hintlastnview");
register_tabledrop("batchdelete");
register_tabledrop("ftpusers");
register_tabledrop("ipban");
register_tabledrop("ban");
register_tabledrop("logaccess");
register_tabledrop("fvcache");
register_tabledrop("userpic_comment");
register_tabledrop("events");
register_tabledrop("randomuserset");

register_tablecreate("portal", <<'EOC');
CREATE TABLE portal (
  userid int(10) unsigned NOT NULL default '0',
  loc enum('left','main','right','moz') NOT NULL default 'left',
  pos tinyint(3) unsigned NOT NULL default '0',
  boxname varchar(30) default NULL,
  boxargs varchar(255) default NULL,
  PRIMARY KEY  (userid,loc,pos),
  KEY boxname (boxname)
)
EOC

register_tablecreate("portal_box_prop", <<'EOC');
CREATE TABLE portal_box_prop (
                              userid INT(10),
                              pboxid SMALLINT,
                              ppropid SMALLINT,
                              propvalue VARCHAR(255) BINARY,
                              PRIMARY KEY(userid, pboxid, ppropid)
)
EOC

register_tablecreate("portal_config", <<'EOC');
CREATE TABLE portal_config (
                            userid INT(10),
                            pboxid SMALLINT,
                            col CHAR(1),
                            sortorder TINYINT,
                            type INT,
                            PRIMARY KEY(userid,pboxid)
)
EOC

register_tablecreate("portal_typemap", <<'EOC');
CREATE TABLE portal_typemap (
                             id SMALLINT UNSIGNED AUTO_INCREMENT NOT NULL,
                             class_name VARCHAR(255),
                             PRIMARY KEY (id),
                             UNIQUE (class_name)
)
EOC

register_tablecreate("infohistory", <<'EOC');
CREATE TABLE infohistory (
  userid int(10) unsigned NOT NULL default '0',
  what varchar(15) NOT NULL default '',
  timechange datetime NOT NULL default '0000-00-00 00:00:00',
  oldvalue varchar(255) default NULL,
  other varchar(30) default NULL,
  KEY userid (userid)
)
EOC

register_tablecreate("useridmap", <<'EOC');
CREATE TABLE useridmap (
  userid int(10) unsigned NOT NULL,
  user char(15) NOT NULL,
  PRIMARY KEY  (userid),
  UNIQUE KEY user (user)
)
EOC

post_create("useridmap",
            "sqltry" => "REPLACE INTO useridmap (userid, user) SELECT userid, user FROM user",
            );

register_tablecreate("userusage", <<'EOC');
CREATE TABLE userusage
(
   userid INT UNSIGNED NOT NULL,
   PRIMARY KEY (userid),
   timecreate DATETIME NOT NULL,
   timeupdate DATETIME,
   timecheck DATETIME,
   lastitemid INT UNSIGNED NOT NULL DEFAULT '0',
   INDEX (timeupdate)
)
EOC

# wknum - number of weeks past unix epoch time
# ubefore - units before next week (unit = 10 seconds)
# uafter - units after this week (unit = 10 seconds)
register_tablecreate("weekuserusage", <<'EOC');
CREATE TABLE weekuserusage
(
   wknum  SMALLINT UNSIGNED NOT NULL,
   userid INT UNSIGNED NOT NULL,
   PRIMARY KEY (wknum, userid),
   ubefore  SMALLINT UNSIGNED NOT NULL,
   uafter   SMALLINT UNSIGNED NOT NULL
)
EOC

post_create("userusage",
            "sqltry" => "INSERT IGNORE INTO userusage (userid, timecreate, timeupdate, timecheck, lastitemid) SELECT userid, timecreate, timeupdate, timecheck, lastitemid FROM user",
            "sqltry" => "ALTER TABLE user DROP timecreate, DROP timeupdate, DROP timecheck, DROP lastitemid",
            );

register_tablecreate("acctcode", <<'EOC');
CREATE TABLE acctcode
(
  acid    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  userid  INT UNSIGNED NOT NULL,
  rcptid  INT UNSIGNED NOT NULL DEFAULT 0,
  auth    CHAR(5) NOT NULL,
  INDEX (userid),
  INDEX (rcptid)
)
EOC

register_tablecreate("meme", <<'EOC');
CREATE TABLE meme (
  url       VARCHAR(150) NOT NULL,
  posterid  INT UNSIGNED NOT NULL,
  UNIQUE (url, posterid),
  ts        TIMESTAMP,
  itemid    INT UNSIGNED NOT NULL,
  INDEX (ts)
)
EOC

register_tablecreate("statushistory", <<'EOC');
CREATE TABLE statushistory (
  userid    INT UNSIGNED NOT NULL,
  adminid   INT UNSIGNED NOT NULL,
  shtype    VARCHAR(20) NOT NULL,
  shdate    TIMESTAMP NOT NULL,
  notes     TEXT,
  INDEX (userid, shdate),
  INDEX (adminid, shdate),
  INDEX (adminid, shtype, shdate),
  INDEX (shtype, shdate)
)
EOC

register_tablecreate("includetext", <<'EOC');
CREATE TABLE includetext (
  incname  VARCHAR(80) NOT NULL PRIMARY KEY,
  inctext  TEXT,
  updatetime   INT UNSIGNED NOT NULL,
  INDEX (updatetime)
)
EOC

register_tablecreate("oldids", <<'EOC');
CREATE TABLE oldids (
  area     CHAR(1) NOT NULL,
  oldid    INT UNSIGNED NOT NULL,
  UNIQUE (area, oldid),
  userid   INT UNSIGNED NOT NULL,
  newid    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (area,userid, newid),
  INDEX (userid)
) TYPE=MYISAM
EOC

register_tablecreate("dudata", <<'EOC');
CREATE TABLE dudata (
  userid   INT UNSIGNED NOT NULL,
  area     CHAR(1) NOT NULL,
  areaid   INT UNSIGNED NOT NULL,
  bytes    MEDIUMINT UNSIGNED NOT NULL,
  PRIMARY KEY (userid, area, areaid)
)
EOC

register_tablecreate("dbinfo", <<'EOC');
CREATE TABLE dbinfo (
  dbid    TINYINT UNSIGNED NOT NULL,
  name    VARCHAR(25),
  fdsn      VARCHAR(255),
  rootfdsn  VARCHAR(255),
  masterid  TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (dbid),
  UNIQUE (name)
)
EOC

register_tablecreate("dbweights", <<'EOC');
CREATE TABLE dbweights (
  dbid    TINYINT UNSIGNED NOT NULL,
  role    VARCHAR(25) NOT NULL,
  PRIMARY KEY (dbid, role),
  norm    TINYINT UNSIGNED NOT NULL,
  curr    TINYINT UNSIGNED NOT NULL
)
EOC

# Begin S2 Stuff
register_tablecreate("s2layers", <<'EOC'); # global
CREATE TABLE s2layers
(
   s2lid INT UNSIGNED NOT NULL AUTO_INCREMENT,
   PRIMARY KEY (s2lid),
   b2lid INT UNSIGNED NOT NULL,
   userid INT UNSIGNED NOT NULL,
   type ENUM('core','i18nc','layout','theme','i18n','user') NOT NULL,
   INDEX (userid),
   INDEX (b2lid, type)
)
EOC

register_tablecreate("s2info", <<'EOC'); # global
CREATE TABLE s2info
(
   s2lid INT UNSIGNED NOT NULL,
   infokey   VARCHAR(80) NOT NULL,
   value VARCHAR(255) NOT NULL,
   PRIMARY KEY (s2lid, infokey)
)
EOC

register_tablecreate("s2source", <<'EOC'); # global
CREATE TABLE s2source
(
   s2lid INT UNSIGNED NOT NULL,
   PRIMARY KEY (s2lid),
   s2code MEDIUMBLOB
)
EOC

register_tablecreate("s2source_inno", <<'EOC'); # global
CREATE TABLE s2source_inno
(
   s2lid INT UNSIGNED NOT NULL,
   PRIMARY KEY (s2lid),
   s2code MEDIUMBLOB
) TYPE=InnoDB
EOC

register_tablecreate("s2checker", <<'EOC'); # global
CREATE TABLE s2checker
(
   s2lid INT UNSIGNED NOT NULL,
   PRIMARY KEY (s2lid),
   checker MEDIUMBLOB
)
EOC

# the original global s2compiled table.  see comment below for new version.
register_tablecreate("s2compiled", <<'EOC'); # global (compdata is not gzipped)
CREATE TABLE s2compiled
(
   s2lid INT UNSIGNED NOT NULL,
   PRIMARY KEY (s2lid),
   comptime INT UNSIGNED NOT NULL,
   compdata MEDIUMBLOB
)
EOC

# s2compiled2 is only for user S2 layers (not system) and is lazily
# migrated.  new saves go here.  loads try this table first (unless
# system) and if miss, then try the s2compiled table on the global.
register_tablecreate("s2compiled2", <<'EOC'); # clustered (compdata is gzipped)
CREATE TABLE s2compiled2
(
   userid INT UNSIGNED NOT NULL,
   s2lid INT UNSIGNED NOT NULL,
   PRIMARY KEY (userid, s2lid),

   comptime INT UNSIGNED NOT NULL,
   compdata MEDIUMBLOB
)
EOC

register_tablecreate("s2styles", <<'EOC'); # global
CREATE TABLE s2styles
(
   styleid INT UNSIGNED NOT NULL AUTO_INCREMENT,
   PRIMARY KEY (styleid),
   userid  INT UNSIGNED NOT NULL,
   name    VARCHAR(255),
   modtime INT UNSIGNED NOT NULL,
   INDEX (userid)
)
EOC

register_tablecreate("s2stylelayers", <<'EOC'); # global
CREATE TABLE s2stylelayers
(
    styleid INT UNSIGNED NOT NULL,
    type ENUM('core','i18nc','layout','theme','i18n','user') NOT NULL,
    UNIQUE (styleid, type),
    s2lid INT UNSIGNED NOT NULL
)
EOC

register_tablecreate("s2stylelayers2", <<'EOC'); # clustered
CREATE TABLE s2stylelayers2
(
    userid  INT UNSIGNED NOT NULL,
    styleid INT UNSIGNED NOT NULL,
    type ENUM('core','i18nc','layout','theme','i18n','user') NOT NULL,
    PRIMARY KEY (userid, styleid, type),
    s2lid INT UNSIGNED NOT NULL
)
EOC


register_tablecreate("ml_domains", <<'EOC');
CREATE TABLE ml_domains
(
  dmid TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (dmid),
  type VARCHAR(30) NOT NULL,
  args VARCHAR(255) NOT NULL DEFAULT '',
  UNIQUE (type,args)
)
EOC

register_tablecreate("ml_items", <<'EOC');
CREATE TABLE ml_items
(
   dmid    TINYINT UNSIGNED NOT NULL,
   itid    MEDIUMINT UNSIGNED AUTO_INCREMENT NOT NULL,
   PRIMARY KEY (dmid, itid),
   itcode  VARCHAR(80) NOT NULL,
   UNIQUE  (dmid, itcode),
   notes   MEDIUMTEXT
) TYPE=MYISAM
EOC

register_tablecreate("ml_langs", <<'EOC');
CREATE TABLE ml_langs
(
   lnid      SMALLINT UNSIGNED NOT NULL,
   UNIQUE (lnid),
   lncode   VARCHAR(16) NOT NULL,  # en_US en_LJ en ch_HK ch_B5 etc... de_DE
   UNIQUE (lncode),
   lnname   VARCHAR(60) NOT NULL,   # "Deutsch"
   parenttype   ENUM('diff','sim') NOT NULL,
   parentlnid   SMALLINT UNSIGNED NOT NULL,
   lastupdate  DATETIME NOT NULL
)
EOC

register_tablecreate("ml_langdomains", <<'EOC');
CREATE TABLE ml_langdomains
(
   lnid   SMALLINT UNSIGNED NOT NULL,
   dmid   TINYINT UNSIGNED NOT NULL,
   PRIMARY KEY (lnid, dmid),
   dmmaster ENUM('0','1') NOT NULL,
   lastgetnew DATETIME,
   lastpublish DATETIME,
   countokay    SMALLINT UNSIGNED NOT NULL,
   counttotal   SMALLINT UNSIGNED NOT NULL
)
EOC

register_tablecreate("ml_latest", <<'EOC');
CREATE TABLE ml_latest
(
   lnid     SMALLINT UNSIGNED NOT NULL,
   dmid     TINYINT UNSIGNED NOT NULL,
   itid     SMALLINT UNSIGNED NOT NULL,
   PRIMARY KEY (lnid, dmid, itid),
   txtid    INT UNSIGNED NOT NULL,
   chgtime  DATETIME NOT NULL,
   staleness  TINYINT UNSIGNED DEFAULT 0 NOT NULL, # better than ENUM('0','1','2');
   revid    INT UNSIGNED,
   INDEX (lnid, staleness),
   INDEX (dmid, itid),
   INDEX (lnid, dmid, chgtime),
   INDEX (chgtime)
)
EOC

register_tablecreate("ml_text", <<'EOC');
CREATE TABLE ml_text
(
   dmid  TINYINT UNSIGNED NOT NULL,
   txtid  INT UNSIGNED AUTO_INCREMENT NOT NULL,
   PRIMARY KEY (dmid, txtid),
   lnid   SMALLINT UNSIGNED NOT NULL,
   itid   SMALLINT UNSIGNED NOT NULL,
   INDEX (lnid, dmid, itid),
   text    TEXT NOT NULL,
   userid  INT UNSIGNED NOT NULL
) TYPE=MYISAM
EOC

register_tablecreate("domains", <<'EOC');
CREATE TABLE domains
(
   domain  VARCHAR(80) NOT NULL,
   PRIMARY KEY (domain),
   userid  INT UNSIGNED NOT NULL,
   INDEX (userid)
)
EOC

register_tablecreate("procnotify", <<'EOC');
CREATE TABLE procnotify
(
   nid   INT UNSIGNED NOT NULL AUTO_INCREMENT,
   PRIMARY KEY (nid),
   cmd   VARCHAR(50),
   args  VARCHAR(255)
)
EOC

register_tablecreate("syndicated", <<'EOC');
CREATE TABLE syndicated
(
   userid  INT UNSIGNED NOT NULL,
   synurl  VARCHAR(255),
   checknext  DATETIME NOT NULL,
   lastcheck  DATETIME,
   lastmod    INT UNSIGNED, # unix time
   etag       VARCHAR(80),
   PRIMARY KEY (userid),
   UNIQUE (synurl),
   INDEX (checknext)
)
EOC

register_tablecreate("synitem", <<'EOC');
CREATE TABLE synitem
(
   userid  INT UNSIGNED NOT NULL,
   item   CHAR(22),    # base64digest of rss $item
   dateadd DATETIME NOT NULL,
   INDEX (userid, item(3)),
   INDEX (userid, dateadd)
)
EOC

register_tablecreate("ratelist", <<'EOC');
CREATE TABLE ratelist
(
 rlid TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
 name  varchar(50) not null,
 des varchar(255) not null,
 PRIMARY KEY (rlid),
 UNIQUE KEY (name)
 )
EOC

register_tablecreate("ratelog", <<'EOC');
CREATE TABLE ratelog
(
 userid   INT UNSIGNED NOT NULL,
 rlid  TINYINT UNSIGNED NOT NULL,
 evttime  INT UNSIGNED NOT NULL,
 ip       INT UNSIGNED NOT NULL,
 index (userid, rlid, evttime),
 quantity SMALLINT UNSIGNED NOT NULL
 )
EOC

register_tablecreate("rateabuse", <<'EOC');
CREATE TABLE rateabuse
(
 rlid     TINYINT UNSIGNED NOT NULL,
 userid   INT UNSIGNED NOT NULL,
 evttime  INT UNSIGNED NOT NULL,
 ip       INT UNSIGNED NOT NULL,
 enum     ENUM('soft','hard') NOT NULL,
 index (rlid, evttime),
 index (userid),
 index (ip)
 )
EOC

register_tablecreate("loginstall", <<'EOC');
CREATE TABLE loginstall
(
 userid   INT UNSIGNED NOT NULL,
 ip       INT UNSIGNED NOT NULL,
 time     INT UNSIGNED NOT NULL,
 UNIQUE (userid, ip)
 )
EOC

# web sessions.  optionally tied to ips and with expiration times.
# whenever a session is okayed, expired ones are deleted, or ones
# created over 30 days ago.  a live session can't change email address
# or password.  digest authentication will be required for that,
# or javascript md5 challenge/response.
register_tablecreate("sessions", <<'EOC'); # user cluster
CREATE TABLE sessions (
   userid     MEDIUMINT UNSIGNED NOT NULL,
   sessid     MEDIUMINT UNSIGNED NOT NULL,
   PRIMARY KEY (userid, sessid),
   auth       CHAR(10) NOT NULL,
   exptype    ENUM('short','long') NOT NULL,  # browser closed or "infinite"
   timecreate INT UNSIGNED NOT NULL,
   timeexpire INT UNSIGNED NOT NULL,
   ipfixed    CHAR(15)  # if null, not fixed at IP.
)
EOC

register_tablecreate("sessions_data", <<'EOC');  # user cluster
CREATE TABLE sessions_data (
   userid     MEDIUMINT UNSIGNED NOT NULL,
   sessid     MEDIUMINT UNSIGNED NOT NULL,
   skey       VARCHAR(30) NOT NULL,
   PRIMARY KEY (userid, sessid, skey),
   sval       VARCHAR(255)
)
EOC

# what:  ip, email, ljuser, ua, emailnopay
# emailnopay means don't allow payments from that email
register_tablecreate("sysban", <<'EOC');
CREATE TABLE sysban (
   banid     MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
   PRIMARY KEY (banid),
   status    ENUM('active','expired') NOT NULL DEFAULT 'active',
   INDEX     (status),
   bandate   DATETIME,
   banuntil  DATETIME,
   what      VARCHAR(20) NOT NULL,
   value     VARCHAR(80),
   note      VARCHAR(255)
)
EOC

# clustered relationship types are defined in ljlib.pl and ljlib-local.pl in
# the LJ::get_reluser_id function
register_tablecreate("reluser2", <<'EOC');
CREATE TABLE reluser2 (
  userid    INT UNSIGNED NOT NULL,
  type      SMALLINT UNSIGNED NOT NULL,
  targetid  INT UNSIGNED NOT NULL,
  PRIMARY KEY (userid,type,targetid),
  INDEX (userid,targetid)
)
EOC

# relationship types:
# 'A' means targetid can administrate userid as a community maintainer
# 'B' means targetid is banned in userid
# 'P' means targetid can post to userid
# 'M' means targetid can moderate the community userid
# 'N' means targetid is preapproved to post to community userid w/o moderation
# 'I' means targetid invited userid to the site
# new types to be added here

register_tablecreate("reluser", <<'EOC');
CREATE TABLE reluser (
  userid     INT UNSIGNED NOT NULL,
  targetid   INT UNSIGNED NOT NULL,
  type       char(1) NOT NULL,
  PRIMARY KEY (userid,type,targetid),
  KEY (targetid,type)
)
EOC

post_create("reluser",
            "sqltry" => "INSERT IGNORE INTO reluser (userid, targetid, type) SELECT userid, banneduserid, 'B' FROM ban",
            "sqltry" => "INSERT IGNORE INTO reluser (userid, targetid, type) SELECT u.userid, p.userid, 'A' FROM priv_map p, priv_list l, user u WHERE l.privcode='sharedjournal' AND l.prlid=p.prlid AND p.arg=u.user AND p.arg<>'all'",
            "code" => sub {

                # logaccess has been dead for a long time.  In fact, its table
                # definition has been removed from this file.  No need to try
                # and upgrade if the source table doesn't even exist.
                unless (column_type('logaccess', 'userid')) {
                    print "# No logaccess source table found, skipping...\n";
                    return;
                }

                my $dbh = shift;
                print "# Converting logaccess rows to reluser...\n";
                my $sth = $dbh->prepare("SELECT MAX(userid) FROM user");
                $sth->execute;
                my ($maxid) = $sth->fetchrow_array;
                return unless $maxid;

                my $from = 1; my $to = $from + 10000 - 1;
                while ($from <= $maxid) {
                    printf "#  logaccess status: (%0.1f%%)\n", ($from * 100 / $maxid);
                    do_sql("INSERT IGNORE INTO reluser (userid, targetid, type) ".
                           "SELECT ownerid, posterid, 'P' ".
                           "FROM logaccess ".
                           "WHERE ownerid BETWEEN $from AND $to");
                    $from += 10000;
                    $to += 10000;
                }
                print "# Finished converting logaccess.\n";
            },
            );

register_tablecreate("clustermove", <<'EOC');
CREATE TABLE clustermove (
   cmid      INT UNSIGNED NOT NULL AUTO_INCREMENT,
   PRIMARY KEY (cmid),
   userid    INT UNSIGNED NOT NULL,
   KEY (userid),
   sclust    TINYINT UNSIGNED NOT NULL,
   dclust    TINYINT UNSIGNED NOT NULL,
   timestart INT UNSIGNED,
   timedone  INT UNSIGNED,
   sdeleted  ENUM('1','0')
)
EOC

# moderated community post summary info
register_tablecreate("modlog", <<'EOC');
CREATE TABLE modlog (
  journalid  INT UNSIGNED NOT NULL,
  modid      MEDIUMINT UNSIGNED NOT NULL,
  PRIMARY KEY (journalid, modid),
  posterid   INT UNSIGNED NOT NULL,
  subject    CHAR(30),
  logtime    DATETIME,
  KEY (journalid, logtime)
)
EOC

# moderated community post Storable object (all props/options)
register_tablecreate("modblob", <<'EOC');
CREATE TABLE modblob (
  journalid  INT UNSIGNED NOT NULL,
  modid      INT UNSIGNED NOT NULL,
  PRIMARY KEY (journalid, modid),
  request_stor    MEDIUMBLOB
)
EOC

# user counters
register_tablecreate("counter", <<'EOC');
CREATE TABLE counter (
  journalid  INT UNSIGNED NOT NULL,
  area       CHAR(1) NOT NULL,
  PRIMARY KEY (journalid, area),
  max        MEDIUMINT UNSIGNED NOT NULL
)
EOC

# user counters on the global (contrary to the name)
register_tablecreate("usercounter", <<'EOC');
CREATE TABLE usercounter (
  journalid  INT UNSIGNED NOT NULL,
  area       CHAR(1) NOT NULL,
  PRIMARY KEY (journalid, area),
  max        INT UNSIGNED NOT NULL
)
EOC

# community interests
register_tablecreate("comminterests", <<'EOC');
CREATE TABLE comminterests (
  userid int(10) unsigned NOT NULL default '0',
  intid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (userid,intid),
  KEY (intid)
)
EOC

# links
register_tablecreate("links", <<'EOC'); # clustered
CREATE TABLE links (
  journalid int(10) unsigned NOT NULL default '0',
  ordernum tinyint(4) unsigned NOT NULL default '0',
  parentnum tinyint(4) unsigned NOT NULL default '0',
  url varchar(255) default NULL,
  title varchar(255) NOT NULL default '',
  KEY  (journalid)
)
EOC

# supportprop
register_tablecreate("supportprop", <<'EOC');
CREATE TABLE supportprop (
  spid int(10) unsigned NOT NULL default '0',
  prop varchar(30) NOT NULL,
  value varchar(255) NOT NULL,
  PRIMARY KEY (spid, prop)
)
EOC

# s1overrides
register_tablecreate("s1overrides", <<'EOC'); # clustered
CREATE TABLE s1overrides (
  userid int unsigned NOT NULL default '0',
  override text NOT NULL,
  PRIMARY KEY  (userid)
)
EOC

# s1style
register_tablecreate("s1style", <<'EOC'); # clustered
CREATE TABLE s1style (
  styleid int(11) NOT NULL auto_increment,
  userid int(11) unsigned NOT NULL,
  styledes varchar(50) default NULL,
  type varchar(10) NOT NULL default '',
  formatdata text,
  is_public enum('Y','N') NOT NULL default 'N',
  is_embedded enum('Y','N') NOT NULL default 'N',
  is_colorfree enum('Y','N') NOT NULL default 'N',
  opt_cache enum('Y','N') NOT NULL default 'N',
  has_ads enum('Y','N') NOT NULL default 'N',
  lastupdate datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (styleid),
  KEY (userid)

)
EOC

# s1stylemap
register_tablecreate("s1stylemap", <<'EOC'); # global
CREATE TABLE s1stylemap (
   styleid int unsigned NOT NULL,
   userid int unsigned NOT NULL,
   PRIMARY KEY (styleid)
)
EOC

# comment urls
register_tablecreate("commenturls", <<'EOC'); # global
CREATE TABLE commenturls (
   posterid int unsigned NOT NULL,
   journalid int unsigned NOT NULL,
   jtalkid int unsigned NOT NULL,
   timecreate int unsigned NOT NULL,
   url varchar(255) NOT NULL,
   INDEX (timecreate)
)
EOC

post_create("comminterests",
            "code" => sub {
                my $dbh = shift;
                print "# Populating community interests...\n";

                my $BLOCK = 1_000;

                my @ids = @{ $dbh->selectcol_arrayref("SELECT userid FROM community") || [] };
                my $total = @ids;

                while (@ids) {
                    my @set = grep { $_ } splice(@ids, 0, $BLOCK);

                    printf ("# community interests status: (%0.1f%%)\n",
                            ((($total - @ids) / $total) * 100)) if $total > $BLOCK;

                    local $" = ",";
                    do_sql("INSERT IGNORE INTO comminterests (userid, intid) ".
                           "SELECT userid, intid FROM userinterests " .
                           "WHERE userid IN (@set)");
                }

                print "# Finished converting community interests.\n";
            },
            );

# tracking where users are active
register_tablecreate("clustertrack2", <<'EOC'); # clustered
CREATE TABLE clustertrack2 (
    userid INT UNSIGNED NOT NULL,
    PRIMARY KEY (userid),
    timeactive INT UNSIGNED NOT NULL,
    clusterid SMALLINT UNSIGNED,
    INDEX (timeactive, clusterid)
)
EOC

# rotating site secret values
register_tablecreate("secrets", <<'EOC'); # global
CREATE TABLE secrets  (
    stime   INT UNSIGNED NOT NULL,
    secret  CHAR(32) NOT NULL,
    PRIMARY KEY (stime)
)
EOC

# Captcha table
register_tablecreate("captchas", <<'EOC');
CREATE TABLE captchas (
    capid       INT UNSIGNED NOT NULL auto_increment,
    type        enum('image','audio'),
    issuetime   INT UNSIGNED NOT NULL DEFAULT 0,
    answer      CHAR(10),
    userid      INT UNSIGNED NOT NULL DEFAULT 0,
    anum        SMALLINT UNSIGNED NOT NULL,
    INDEX(type,issuetime),
    INDEX(userid),
    PRIMARY KEY(capid)
)
EOC

# Challenges table (for non-memcache support)
register_tablecreate("challenges", <<'EOC');
CREATE TABLE challenges (
    ctime int(10) unsigned NOT NULL DEFAULT 0,
    challenge char(80) NOT NULL DEFAULT '',
    PRIMARY KEY (challenge)
)
EOC

register_tablecreate("clustermove_inprogress", <<'EOC');
CREATE TABLE clustermove_inprogress (
    userid      INT UNSIGNED NOT NULL,
    locktime    INT UNSIGNED NOT NULL,
    dstclust    SMALLINT UNSIGNED NOT NULL,
    moverhost   INT UNSIGNED NOT NULL,
    moverport   SMALLINT UNSIGNED NOT NULL,
    moverinstance CHAR(22) NOT NULL, # base64ed MD5 hash
    PRIMARY KEY (userid)
)
EOC

# track open HTTP proxies
register_tablecreate("openproxy", <<'EOC');
CREATE TABLE openproxy (
    addr        VARCHAR(15) NOT NULL,
    status      ENUM('proxy', 'clear'),
    asof        INT UNSIGNED NOT NULL,
    src         VARCHAR(80),
    PRIMARY KEY (addr)
)
EOC

register_tablecreate("captcha_session", <<'EOC');  # clustered
CREATE TABLE captcha_session (
    sess char(20) NOT NULL default '',
    sesstime int(10) unsigned NOT NULL default '0',
    lastcapid int(11) default NULL,
    trynum smallint(6) default '0',
    PRIMARY KEY  (`sess`),
    KEY sesstime (`sesstime`)
)
EOC

register_tablecreate("spamreports", <<'EOC'); # global
CREATE TABLE spamreports (
    reporttime  INT(10) UNSIGNED NOT NULL,
    ip          VARCHAR(15),
    journalid   INT(10) UNSIGNED NOT NULL,
    posterid    INT(10) UNSIGNED NOT NULL DEFAULT 0,
    subject     VARCHAR(255) BINARY,
    body        BLOB NOT NULL,
    PRIMARY KEY (reporttime, journalid),
    INDEX       (ip),
    INDEX       (posterid)
)
EOC

register_tablecreate("tempanonips", <<'EOC'); # clustered
CREATE TABLE tempanonips (
    reporttime  INT(10) UNSIGNED NOT NULL,
    ip          VARCHAR(15) NOT NULL,
    journalid   INT(10) UNSIGNED NOT NULL,
    jtalkid     MEDIUMINT(8) UNSIGNED NOT NULL,
    PRIMARY KEY (journalid, jtalkid),
    INDEX       (reporttime)
)
EOC

# partialstats - stores calculation times:
#    jobname = 'calc_country'
#    clusterid = '1'
#    calctime = time()
register_tablecreate("partialstats", <<'EOC');
CREATE TABLE partialstats (
    jobname  VARCHAR(50) NOT NULL,
    clusterid MEDIUMINT NOT NULL DEFAULT 0,
    calctime  INT(10) UNSIGNED,
    PRIMARY KEY (jobname, clusterid)
)
EOC

# partialstatsdata - stores data per cluster:
#    statname = 'country'
#    arg = 'US'
#    clusterid = '1'
#    value = '500'
register_tablecreate("partialstatsdata", <<'EOC');
CREATE TABLE partialstatsdata (
    statname  VARCHAR(50) NOT NULL,
    arg       VARCHAR(50) NOT NULL,
    clusterid INT(10) UNSIGNED NOT NULL DEFAULT 0,
    value     INT(11),
    PRIMARY KEY (statname, arg, clusterid)
)
EOC

# inviterecv -- stores community invitations received
register_tablecreate("inviterecv", <<'EOC');
CREATE TABLE inviterecv (
    userid      INT(10) UNSIGNED NOT NULL,
    commid      INT(10) UNSIGNED NOT NULL,
    maintid     INT(10) UNSIGNED NOT NULL,
    recvtime    INT(10) UNSIGNED NOT NULL,
    args        VARCHAR(255),
    PRIMARY KEY (userid, commid)
)
EOC

# invitesent -- stores community invitations sent
register_tablecreate("invitesent", <<'EOC');
CREATE TABLE invitesent (
    commid      INT(10) UNSIGNED NOT NULL,
    userid      INT(10) UNSIGNED NOT NULL,
    maintid     INT(10) UNSIGNED NOT NULL,
    recvtime    INT(10) UNSIGNED NOT NULL,
    status      ENUM('accepted', 'rejected', 'outstanding') NOT NULL,
    args        VARCHAR(255),
    PRIMARY KEY (commid, userid)
)
EOC

# memorable2 -- clustered memories
register_tablecreate("memorable2", <<'EOC');
CREATE TABLE memorable2 (
    userid      INT(10) UNSIGNED NOT NULL DEFAULT '0',
    memid       INT(10) UNSIGNED NOT NULL DEFAULT '0',
    journalid   INT(10) UNSIGNED NOT NULL DEFAULT '0',
    ditemid     INT(10) UNSIGNED NOT NULL DEFAULT '0',
    des         VARCHAR(150) DEFAULT NULL,
    security    ENUM('public','friends','private') NOT NULL DEFAULT 'public',
    PRIMARY KEY (userid, journalid, ditemid),
    UNIQUE KEY  (userid, memid)
)
EOC

# memkeyword2 -- clustered memory keyword map
register_tablecreate("memkeyword2", <<'EOC');
CREATE TABLE memkeyword2 (
    userid      INT(10) UNSIGNED NOT NULL DEFAULT '0',
    memid       INT(10) UNSIGNED NOT NULL DEFAULT '0',
    kwid        INT(10) UNSIGNED NOT NULL DEFAULT '0',
    PRIMARY KEY (userid, memid, kwid),
    KEY         (userid, kwid)
)
EOC

# userkeywords -- clustered keywords
register_tablecreate("userkeywords", <<'EOC');
CREATE TABLE userkeywords (
    userid      INT(10) UNSIGNED NOT NULL DEFAULT '0',
    kwid        INT(10) UNSIGNED NOT NULL DEFAULT '0',
    keyword     VARCHAR(80) BINARY NOT NULL,
    PRIMARY KEY (userid, kwid),
    UNIQUE KEY  (userid, keyword)
)
EOC

# friendgroup2 -- clustered friend groups
register_tablecreate("friendgroup2", <<'EOC');
CREATE TABLE friendgroup2 (
    userid      INT(10) UNSIGNED NOT NULL DEFAULT '0',
    groupnum    TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
    groupname   VARCHAR(90) NOT NULL DEFAULT '',
    sortorder   TINYINT(3) UNSIGNED NOT NULL DEFAULT '50',
    is_public   ENUM('0','1') NOT NULL DEFAULT '0',
    PRIMARY KEY (userid, groupnum)
)
EOC

register_tablecreate("readonly_user", <<'EOC');
CREATE TABLE readonly_user (
    userid      INT(10) UNSIGNED NOT NULL DEFAULT '0',
    PRIMARY KEY (userid)
)
EOC

register_tablecreate("underage", <<'EOC');
CREATE TABLE underage (
    uniq        CHAR(15) NOT NULL,
    timeof      INT(10) NOT NULL,
    PRIMARY KEY (uniq),
    KEY         (timeof)
)
EOC

register_tablecreate("support_youreplied", <<'EOC');
CREATE TABLE support_youreplied (
    userid  INT UNSIGNED NOT NULL,
    spid    INT UNSIGNED NOT NULL,
    PRIMARY KEY (userid, spid)
)
EOC

register_tablecreate("support_answers", <<'EOC');
CREATE TABLE support_answers (
    ansid INT UNSIGNED NOT NULL,
    spcatid INT UNSIGNED NOT NULL,
    lastmodtime INT UNSIGNED NOT NULL,
    lastmoduserid INT UNSIGNED NOT NULL,
    subject VARCHAR(255),
    body TEXT,

    PRIMARY KEY (ansid),
    KEY         (spcatid)
)
EOC

register_tablecreate("userlog", <<'EOC');
CREATE TABLE userlog (
    userid        INT UNSIGNED NOT NULL,
    logtime       INT UNSIGNED NOT NULL,
    action        VARCHAR(30) NOT NULL,
    actiontarget  INT UNSIGNED,
    remoteid      INT UNSIGNED,
    ip            VARCHAR(15),
    uniq          VARCHAR(15),
    extra         VARCHAR(255),

    INDEX (userid)
)
EOC

# external user mappings
# note: extuser/extuserid are expected to sometimes be NULL, even
# though they are keyed.  (Null values are not taken into account when
# using indexes)
register_tablecreate("extuser", <<'EOC');
CREATE TABLE extuser (
  userid  INT UNSIGNED NOT NULL PRIMARY KEY,
  siteid  INT UNSIGNED NOT NULL,
  extuser    VARCHAR(50),
  extuserid  INT UNSIGNED,
  UNIQUE KEY `extuser` (siteid, extuser),
  UNIQUE KEY `extuserid` (siteid, extuserid)
)
EOC

# table showing what tags a user has; parentkwid can be null
register_tablecreate("usertags", <<'EOC');
CREATE TABLE usertags (
    journalid   INT UNSIGNED NOT NULL,
    kwid        INT UNSIGNED NOT NULL,
    parentkwid  INT UNSIGNED,
    display     ENUM('0','1') DEFAULT '1' NOT NULL,
    PRIMARY KEY (journalid, kwid)
)
EOC

# mapping of tags applied to an entry
register_tablecreate("logtags", <<'EOC');
CREATE TABLE logtags (
    journalid INT UNSIGNED NOT NULL,
    jitemid   MEDIUMINT UNSIGNED NOT NULL,
    kwid      INT UNSIGNED NOT NULL,
    PRIMARY KEY (journalid, jitemid, kwid),
    KEY (journalid, kwid)
)
EOC

# logtags but only for the most recent 100 tags-to-entry
register_tablecreate("logtagsrecent", <<'EOC');
CREATE TABLE logtagsrecent (
    journalid INT UNSIGNED NOT NULL,
    jitemid   MEDIUMINT UNSIGNED NOT NULL,
    kwid      INT UNSIGNED NOT NULL,
    PRIMARY KEY (journalid, kwid, jitemid)
)
EOC

# summary counts for security on entry keywords
register_tablecreate("logkwsum", <<'EOC');
CREATE TABLE logkwsum (
    journalid INT UNSIGNED NOT NULL,
    kwid      INT UNSIGNED NOT NULL,
    security  INT UNSIGNED NOT NULL,
    entryct   INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (journalid, kwid, security),
    KEY (journalid, security)
)
EOC

# action history tables
register_tablecreate("actionhistory", <<'EOC');
CREATE TABLE actionhistory (
    time      INT UNSIGNED NOT NULL,
    clusterid TINYINT UNSIGNED NOT NULL,
    what      CHAR(2) NOT NULL,
    count     INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX(time)

)
EOC

register_tablecreate("recentactions", <<'EOC');
CREATE TABLE recentactions (
    what CHAR(2) NOT NULL
) TYPE=MYISAM
EOC

# external identities
#
#   idtype ::=
#      "O" - OpenID
#      "L" - LID (netmesh)
#      "T" - TypeKey
#       ?  - etc
register_tablecreate("identitymap", <<'EOC');
CREATE TABLE identitymap (
  idtype    CHAR(1) NOT NULL,
  identity  VARCHAR(255) BINARY NOT NULL,
  userid    INT unsigned NOT NULL,
  PRIMARY KEY  (idtype, identity),
  KEY          userid (userid)
)
EOC

register_tablecreate("openid_trust", <<'EOC');
CREATE TABLE openid_trust (
  userid int(10) unsigned NOT NULL default '0',
  endpoint_id int(10) unsigned NOT NULL default '0',
  trust_time int(10) unsigned NOT NULL default '0',
  duration enum('always','once') NOT NULL default 'always',
  last_assert_time int(10) unsigned default NULL,
  flags tinyint(3) unsigned default NULL,
  PRIMARY KEY  (userid,endpoint_id),
  KEY endpoint_id (endpoint_id)
)
EOC

register_tablecreate("openid_endpoint", <<'EOC');
CREATE TABLE openid_endpoint (
  endpoint_id int(10) unsigned NOT NULL auto_increment,
  url varchar(255) BINARY NOT NULL default '',
  last_assert_time int(10) unsigned default NULL,
  PRIMARY KEY  (endpoint_id),
  UNIQUE KEY url (url),
  KEY last_assert_time (last_assert_time)
)
EOC

register_tablecreate("openid_external", <<'EOC');
CREATE TABLE openid_external (
  userid int(10) unsigned NOT NULL default '0',
  url varchar(255) binary default NULL,
  KEY userid (userid)
)
EOC

register_tablecreate("schools", <<'EOC');
CREATE TABLE `schools` (
  `schoolid` int(10) unsigned NOT NULL default '0',
  `name` varchar(200) BINARY NOT NULL default '',
  `country` varchar(4) NOT NULL default '',
  `state` varchar(100) BINARY default NULL,
  `city` varchar(100) BINARY NOT NULL default '',
  `url` varchar(255) default NULL,
  PRIMARY KEY  (`schoolid`),
  UNIQUE KEY `country` (`country`,`state`,`city`,`name`)
)
EOC

register_tablecreate("schools_attended", <<'EOC');
CREATE TABLE `schools_attended` (
  `schoolid` int(10) unsigned NOT NULL default '0',
  `userid` int(10) unsigned NOT NULL default '0',
  `year_start` smallint(5) unsigned default NULL,
  `year_end` smallint(5) unsigned default NULL,
  PRIMARY KEY  (`schoolid`,`userid`)
)
EOC

register_tablecreate("schools_pending", <<'EOC');
CREATE TABLE schools_pending (
  `pendid` int(10) unsigned NOT NULL auto_increment,
  `userid` int(10) unsigned NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `country` varchar(4) NOT NULL default '',
  `state` varchar(255) default NULL,
  `city` varchar(255) NOT NULL default '',
  `url` varchar(255) default NULL,
  PRIMARY KEY (`pendid`),
  KEY `userid` (`userid`)
)
EOC

register_tablecreate("user_schools", <<'EOC');
CREATE TABLE `user_schools` (
  `userid` int(10) unsigned NOT NULL default '0',
  `schoolid` int(10) unsigned NOT NULL default '0',
  `year_start` smallint(5) unsigned default NULL,
  `year_end` smallint(5) unsigned default NULL,
  PRIMARY KEY  (`userid`,`schoolid`)
)
EOC

register_tablecreate("priv_packages", <<'EOC');
CREATE TABLE priv_packages (
  pkgid int(10) unsigned NOT NULL auto_increment,
  name varchar(255) NOT NULL default '',
  lastmoduserid int(10) unsigned NOT NULL default 0,
  lastmodtime int(10) unsigned NOT NULL default 0,
  PRIMARY KEY (pkgid),
  UNIQUE KEY (name)
)
EOC

register_tablecreate("priv_packages_content", <<'EOC');
CREATE TABLE priv_packages_content (
  pkgid int(10) unsigned NOT NULL auto_increment,
  privname varchar(20) NOT NULL,
  privarg varchar(40),
  PRIMARY KEY (pkgid, privname, privarg)
)
EOC

#
# tag is lowercase UTF-8
# dest_type:dest is like:
#   PAGE:/partial/path/to/file.bml  (non-SSL)
#   SSL:/pay/foo.bml                (ssl partial path)
#   LJUSER:lj_nifty                 (link to local user account)
#   FAQ:234                         (link to FAQ #234)

register_tablecreate("navtag", <<'EOC');
CREATE TABLE navtag (
   tag       VARCHAR(128) BINARY NOT NULL,
   dest_type VARCHAR(20)  NOT NULL,
   dest      VARCHAR(255) NOT NULL,
   PRIMARY KEY (tag, dest_type, dest)
)
EOC

register_tablecreate("active_user", <<'EOC');
CREATE TABLE active_user (
   userid INT UNSIGNED NOT NULL,
   type   CHAR(1) NOT NULL,
   time   INT UNSIGNED NOT NULL,
   KEY (userid),
   KEY (time)
)
EOC

register_tablecreate("active_user_summary", <<'EOC');
CREATE TABLE active_user_summary (
    year      SMALLINT NOT NULL,
    month     TINYINT NOT NULL,
    day       TINYINT NOT NULL,
    hour      TINYINT NOT NULL,
    clusterid TINYINT UNSIGNED NOT NULL,
    type      CHAR(1) NOT NULL,
    count     INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (year, month, day, hour, clusterid, type)
)
EOC

register_tablecreate("loginlog", <<'EOC');
CREATE TABLE loginlog (
   userid    INT UNSIGNED NOT NULL,
   logintime INT UNSIGNED NOT NULL,
   INDEX     (userid, logintime),
   sessid    MEDIUMINT UNSIGNED NOT NULL,
   ip        VARCHAR(15),
   ua        VARCHAR(100)
)
EOC

register_tablecreate("userblobcache", <<'EOC');
CREATE TABLE userblobcache (
  userid     INT UNSIGNED NOT NULL,
  bckey      VARCHAR(60) NOT NULL,
  PRIMARY KEY (userid, bckey),
  timeexpire  INT UNSIGNED NOT NULL,
  INDEX (timeexpire),
  value    MEDIUMBLOB
)
EOC

# global
register_tablecreate("smsusermap", <<'EOC');
CREATE TABLE smsusermap (
  number     VARCHAR(25) NOT NULL PRIMARY KEY,
  userid     INT UNSIGNED NOT NULL,
  INDEX(userid)
)
EOC

# global
register_tablecreate("smsuniqmap", <<'EOC');
CREATE TABLE smsuniqmap (
   msg_uniq  VARCHAR(25) NOT NULL PRIMARY KEY,
   userid    INT UNSIGNED NOT NULL,
   msgid     MEDIUMINT UNSIGNED NOT NULL
)
EOC

# clustered
register_tablecreate("sms_msg", <<'EOC');
CREATE TABLE sms_msg (
  userid        INT UNSIGNED NOT NULL,
  msgid         MEDIUMINT UNSIGNED NOT NULL,
  timecreate    INT UNSIGNED NOT NULL,
  type          ENUM('incoming', 'outgoing'),
  from_number   VARCHAR(15),
  to_number     VARCHAR(15),
  msg_raw       BLOB NOT NULL,

  PRIMARY KEY (userid, msgid)
)
EOC

# clustered
register_tablecreate("sms_msgack", <<'EOC');
CREATE TABLE sms_msgack (
  userid         INT UNSIGNED NOT NULL,
  msgid          MEDIUMINT UNSIGNED NOT NULL,
  type           ENUM('gateway', 'smsc', 'handset', 'unknown'),
  timerecv       INT UNSIGNED NOT NULL,
  status_flag    ENUM('success', 'error', 'unknown'),
  status_code    VARCHAR(25),
  status_text    VARCHAR(255) NOT NULL,

  INDEX (userid, msgid)
)
EOC

# clustered
register_tablecreate("sms_msgtext", <<'EOC');
CREATE TABLE sms_msgtext (
  userid        INT UNSIGNED NOT NULL,
  msgid         MEDIUMINT UNSIGNED NOT NULL,
  msg_raw       BLOB NOT NULL,
  msg_decoded   BLOB NOT NULL,

  PRIMARY KEY (userid, msgid)
)
EOC

# clustered
register_tablecreate("sms_msgerror", <<'EOC');
CREATE TABLE sms_msgerror (
  userid        INT UNSIGNED NOT NULL,
  msgid         MEDIUMINT UNSIGNED NOT NULL,
  error         TEXT NOT NULL,

  PRIMARY KEY (userid, msgid)
)
EOC

# clustered
register_tablecreate("sms_msgprop", <<'EOC');
CREATE TABLE sms_msgprop (
  userid        INT UNSIGNED NOT NULL,
  msgid         MEDIUMINT UNSIGNED NOT NULL,
  propid        SMALLINT UNSIGNED NOT NULL,
  propval       VARCHAR(255) NOT NULL,

  PRIMARY KEY (userid, msgid, propid)
)
EOC

# unlike most other *proplist tables, this one is auto-populated by app
register_tablecreate("sms_msgproplist", <<'EOC');
CREATE TABLE sms_msgproplist (
  propid  SMALLINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name    VARCHAR(255) DEFAULT NULL,
  UNIQUE KEY (name)
)
EOC

# global
register_tablecreate("usertrans", <<'EOC');
CREATE TABLE `usertrans` (
  `userid` int(10) unsigned NOT NULL default '0',
  `time` int(10) unsigned NOT NULL default '0',
  `what` varchar(25) NOT NULL default '',
  `before` varchar(25) NOT NULL default '',
  `after` varchar(25) NOT NULL default '',
  KEY `userid` (`userid`),
  KEY `time` (`time`)
)
EOC

# global
register_tablecreate("eventtypelist", <<'EOC');
CREATE TABLE eventtypelist (
  etypeid  SMALLINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  class    VARCHAR(100),
  UNIQUE (class)
)
EOC

# global
register_tablecreate("notifytypelist", <<'EOC');
CREATE TABLE notifytypelist (
  ntypeid   SMALLINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  class     VARCHAR(100),
  UNIQUE (class)
)
EOC

# partitioned:  ESN subscriptions:  flag on event target (a journal) saying
#               whether there are known listeners out there.
#
# verifytime is unixtime we last checked that this has_subs caching row
# is still accurate and people do in fact still subscribe to this.
# then maintenance tasks can background prune this table and fix
# up verifytimes.
register_tablecreate("has_subs", <<'EOC');
CREATE TABLE has_subs (
  journalid  INT UNSIGNED NOT NULL,
  etypeid    INT UNSIGNED NOT NULL,
  arg1       INT UNSIGNED NOT NULL,
  arg2       INT UNSIGNED NOT NULL,
  PRIMARY KEY (journalid, etypeid, arg1, arg2),

  verifytime   INT UNSIGNED NOT NULL
)
EOC

# partitioned:  ESN subscriptions:  details of a user's subscriptions
#  subid: alloc_user_counter
#  is_dirty:  either 1 (indexed) or NULL (not in index).  means we have
#             to go update the target's etypeid
#  userid is OWNER of the subscription,
#  journalid is the journal in which the event took place.
#  ntypeid is the notification type from notifytypelist
#  times are unixtimes
#  expiretime can be 0 to mean "never"
#  flags is a bitmask of flags, where:
#     bit 0 = is digest?  (off means live?)
#     rest undefined for now.
register_tablecreate("subs", <<'EOC');
CREATE TABLE subs (
  userid   INT UNSIGNED NOT NULL,
  subid    INT UNSIGNED NOT NULL,
           PRIMARY KEY (userid, subid),

  is_dirty   TINYINT UNSIGNED NULL,
             INDEX (is_dirty),

  journalid  INT UNSIGNED NOT NULL,
  etypeid    SMALLINT UNSIGNED NOT NULL,
  arg1       INT UNSIGNED NOT NULL,
  arg2       INT UNSIGNED NOT NULL,

  ntypeid    SMALLINT UNSIGNED NOT NULL,

  createtime INT UNSIGNED NOT NULL,
  expiretime INT UNSIGNED NOT NULL,
  flags      SMALLINT UNSIGNED NOT NULL
)
EOC

# unlike other *proplist tables, this one is auto-populated by app
register_tablecreate("subsproplist", <<'EOC');
CREATE TABLE subsproplist (
  subpropid  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name       VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (subpropid),
  UNIQUE KEY (name)
)
EOC


# partitioned:  ESN subscriptions:  metadata on a user's subscriptions
register_tablecreate("subsprop", <<'EOC');
CREATE TABLE subsprop (
  userid    INT      UNSIGNED NOT NULL,
  subid     INT      UNSIGNED NOT NULL,
  subpropid SMALLINT UNSIGNED NOT NULL,
            PRIMARY KEY (userid, subid, subpropid),
  value     VARCHAR(255) BINARY DEFAULT NULL
)
EOC


# partitioned:  ESN event queue notification method
register_tablecreate("notifyqueue", <<'EOC');
CREATE TABLE notifyqueue (
  userid     INT UNSIGNED NOT NULL,
  qid        INT UNSIGNED NOT NULL,

  journalid  INT UNSIGNED NOT NULL,
  etypeid    SMALLINT UNSIGNED NOT NULL,
  arg1       INT UNSIGNED,
  arg2       INT UNSIGNED,

  state      CHAR(1) NOT NULL DEFAULT 'N',

  createtime INT UNSIGNED NOT NULL,

  PRIMARY KEY (userid, qid),
  INDEX       (state)
)
EOC

# global (contextual product prodding, "hey, you've never used polls, wanna learn how?")
register_tablecreate("cprodlist", <<'EOC');
CREATE TABLE cprodlist (
  cprodid   SMALLINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  class     VARCHAR(100),
  UNIQUE (class)
)
EOC

# contextual product prodding history, making sure we don't bug people when they
# don't want it anymore.
#
#   -- firstshowtime: when it was first highlighted to them (not all the everything page)
#   -- recentshowtime: a recent showing time.  perhaps not THE most recent, though.
#   -- acktime: time the user saw the box.  either by clicking next/no/more info.
#   -- nothankstime: also a boolean:  time/if user doesn't want to see it again
#   -- clickthrutime:  time user clicked for more info
register_tablecreate("cprod", <<'EOC');
CREATE TABLE cprod (
  userid    INT      UNSIGNED NOT NULL,
  cprodid   SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (userid, cprodid),

  firstshowtime      INT UNSIGNED,
  recentshowtime     INT UNSIGNED,
  acktime            INT UNSIGNED,
  nothankstime       INT UNSIGNED,
  clickthrutime      INT UNSIGNED,
  clickthruver       SMALLINT UNSIGNED
)
EOC

register_tablecreate("sch_funcmap", <<'EOC');
CREATE TABLE sch_funcmap (
        funcid         INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
        funcname       VARCHAR(255) NOT NULL,
        UNIQUE(funcname)
)
EOC

register_tablecreate("sch_job", <<'EOC');
CREATE TABLE sch_job (
        jobid           BIGINT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
        funcid          INT UNSIGNED NOT NULL,
        arg             MEDIUMBLOB,
        uniqkey         VARCHAR(255) NULL,
        insert_time     INTEGER UNSIGNED,
        run_after       INTEGER UNSIGNED NOT NULL,
        grabbed_until   INTEGER UNSIGNED,
        priority        SMALLINT UNSIGNED,
        coalesce        VARCHAR(255),
        INDEX (funcid, run_after),
        UNIQUE(funcid, uniqkey),
        INDEX (funcid, coalesce)
)
EOC

register_tablecreate("sch_note", <<'EOC');
CREATE TABLE sch_note (
        jobid           BIGINT UNSIGNED NOT NULL,
        notekey         VARCHAR(255),
        PRIMARY KEY (jobid, notekey),
        value           MEDIUMBLOB
)
EOC

register_tablecreate("sch_error", <<'EOC');
CREATE TABLE sch_error (
        error_time      INTEGER UNSIGNED NOT NULL,
        jobid           BIGINT UNSIGNED NOT NULL,
        message         VARCHAR(255) NOT NULL,
        INDEX (error_time),
        INDEX (jobid)
)
EOC

register_tablecreate("sch_exitstatus", <<'EOC');
CREATE TABLE sch_exitstatus (
        jobid           BIGINT UNSIGNED PRIMARY KEY NOT NULL,
        status          SMALLINT UNSIGNED,
        completion_time INTEGER UNSIGNED,
        delete_after    INTEGER UNSIGNED,
        INDEX (delete_after)
)
EOC

register_tablecreate("comm_promo_list", <<'EOC');
CREATE TABLE comm_promo_list (
   journalid INT UNSIGNED NOT NULL,
   r_start INT UNSIGNED NOT NULL,
   r_end INT UNSIGNED NOT NULL,
   INDEX (r_start)
)
EOC

register_tablecreate("urimap", <<'EOC');
CREATE TABLE urimap (
  journalid   INTEGER UNSIGNED NOT NULL,
  uri         VARCHAR(255) BINARY NOT NULL,
  PRIMARY KEY (journalid, uri),
  nodetype    CHAR(1) NOT NULL,
  nodeid      INTEGER UNSIGNED NOT NULL,
  INDEX       (journalid, nodetype, nodeid)
)
EOC

register_tablecreate("jabroster", <<'EOC');
CREATE TABLE jabroster (
  userid     INT UNSIGNED NOT NULL,
  contactid  INT UNSIGNED NOT NULL,
  PRIMARY KEY (userid, contactid),
  name       VARCHAR(255) BINARY,
  substate   TINYINT UNSIGNED NOT NULL,
  groups     VARCHAR(255) BINARY,
  ljflags    TINYINT UNSIGNED NOT NULL
)
EOC

register_tablecreate("jabpresence", <<'EOC');
CREATE TABLE jabpresence (
  userid     INT UNSIGNED NOT NULL,
  reshash    CHAR(22) BINARY,
  PRIMARY KEY (userid, reshash),
  resource   VARCHAR(255) NOT NULL,
  client     VARCHAR(255),
  clusterid  INT UNSIGNED NOT NULL,
  presence   BLOB,
  flags      INT UNSIGNED NOT NULL,
  priority   INT UNSIGNED,
  ctime      INT UNSIGNED NOT NULL,
  mtime      INT UNSIGNED NOT NULL,
  remoteip   VARCHAR(255)
)
EOC

register_tablecreate("jabcluster", <<'EOC');
CREATE TABLE jabcluster (
  clusterid  INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  address    VARCHAR(255) NOT NULL
)
EOC

register_tablecreate("jablastseen", <<'EOC');
CREATE TABLE jablastseen (
  userid     INT UNSIGNED NOT NULL PRIMARY KEY,
  presence   BLOB,
  time       INT UNSIGNED NOT NULL,
  motd_ver   INT UNSIGNED
)
EOC

register_tablecreate("usersearch_packdata", <<'EOC');
CREATE TABLE usersearch_packdata (
  userid      INT UNSIGNED NOT NULL PRIMARY KEY,
  packed      CHAR(8) BINARY,
  mtime       INT UNSIGNED NOT NULL,
  good_until  INT UNSIGNED,
  INDEX (mtime),
  INDEX (good_until)
)
EOC

register_tablecreate("knob", <<'EOC');
CREATE TABLE knob (
  knobname    VARCHAR(255) NOT NULL PRIMARY KEY,
  val         TINYINT UNSIGNED
)
EOC

register_tablecreate("debug_notifymethod", <<'EOC');
CREATE TABLE debug_notifymethod (
   userid       int unsigned not null,
   subid        int unsigned,
   ntfytime     int unsigned,
   origntypeid  int unsigned,
   etypeid      int unsigned,
   ejournalid   int unsigned,
   earg1        int,
   earg2        int,
   schjobid     varchar(50) null
)
EOC

register_tablecreate("password", <<'EOC');
CREATE TABLE password (
   userid    INT UNSIGNED NOT NULL PRIMARY KEY,
   password  VARCHAR(50)
)
EOC

register_tablecreate("email", <<'EOC');
CREATE TABLE email (
   userid    INT UNSIGNED NOT NULL PRIMARY KEY,
   email     VARCHAR(50),
   INDEX     (email)
)
EOC

register_tablecreate("dirmogsethandles", <<'EOC');
CREATE TABLE dirmogsethandles (
   conskey  char(40) PRIMARY KEY,
   exptime  INT UNSIGNED NOT NULL,
   INDEX    (exptime)
)
EOC

register_tablecreate("blockwatch_events", <<'EOC');
CREATE TABLE blockwatch_events (
  id int unsigned NOT NULL auto_increment,
  name varchar(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (name)
)
EOC

register_tablecreate("incoming_email_handle", <<'EOC');
CREATE TABLE incoming_email_handle (
  ieid     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  timerecv INT UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY  (ieid)
)
EOC

# global pollid -> userid map
register_tablecreate("pollowner", <<'EOC');
CREATE TABLE pollowner (
  pollid    INT UNSIGNED NOT NULL PRIMARY KEY,
  journalid INT UNSIGNED NOT NULL,
  INDEX (journalid)
)
EOC
  
# clustereds
register_tablecreate("poll2", <<'EOC');
CREATE TABLE poll2 (
  journalid INT UNSIGNED NOT NULL,
  pollid INT UNSIGNED NOT NULL,
  posterid INT UNSIGNED NOT NULL,
  ditemid INT UNSIGNED NOT NULL,
  whovote ENUM('all','friends','ofentry') NOT NULL DEFAULT 'all',
  whoview ENUM('all','friends','ofentry','none') NOT NULL DEFAULT 'all',
  name VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY  (journalid,pollid)
)
EOC

register_tablecreate("pollitem2", <<'EOC');
CREATE TABLE pollitem2 (
  journalid INT UNSIGNED NOT NULL,
  pollid INT UNSIGNED NOT NULL,
  pollqid TINYINT UNSIGNED NOT NULL,
  pollitid TINYINT UNSIGNED NOT NULL,
  sortorder TINYINT UNSIGNED NOT NULL DEFAULT '0',
  item VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY  (journalid,pollid,pollqid,pollitid))
EOC

register_tablecreate("pollquestion2", <<'EOC');
CREATE TABLE pollquestion2 (
  journalid INT UNSIGNED NOT NULL,
  pollid INT UNSIGNED NOT NULL,
  pollqid TINYINT UNSIGNED NOT NULL,
  sortorder TINYINT UNSIGNED NOT NULL DEFAULT '0',
  type ENUM('check','radio','drop','text','scale') NOT NULL,
  opts VARCHAR(20) DEFAULT NULL,
  qtext TEXT,
  PRIMARY KEY  (journalid,pollid,pollqid)
)
EOC

register_tablecreate("pollresult2", <<'EOC');
CREATE TABLE pollresult2 (
  journalid INT UNSIGNED NOT NULL,
  pollid INT UNSIGNED NOT NULL,
  pollqid TINYINT UNSIGNED NOT NULL,
  userid INT UNSIGNED NOT NULL,
  value VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY  (journalid,pollid,pollqid),
  KEY (userid,pollid)
)
EOC

register_tablecreate("pollsubmission2", <<'EOC');
CREATE TABLE pollsubmission2 (
  journalid INT UNSIGNED NOT NULL,
  pollid INT UNSIGNED NOT NULL,
  userid INT UNSIGNED NOT NULL,
  datesubmit DATETIME NOT NULL,
  PRIMARY KEY  (journalid,pollid),
  KEY (userid)
)
EOC

# clustered
register_tablecreate("pollprop2", <<'EOC');
CREATE TABLE pollprop2 (
  journalid INT UNSIGNED NOT NULL,
  pollid INT UNSIGNED NOT NULL,
  propid SMALLINT UNSIGNED NOT NULL,
  propval VARCHAR(255) NOT NULL,
  PRIMARY KEY (journalid,pollid,propid)
)
EOC

register_tablecreate("pollproplist2", <<'EOC');
CREATE TABLE pollproplist2 (
  propid SMALLINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) DEFAULT NULL,
  des VARCHAR(255) DEFAULT NULL,
  scope ENUM('general', 'local') DEFAULT 'general' NOT NULL,
  UNIQUE KEY (name)
)
EOC

# clustered
register_tablecreate("embedcontent", <<'EOC');
CREATE TABLE embedcontent (
  userid     INT UNSIGNED NOT NULL,
  moduleid   INT UNSIGNED NOT NULL,
  content    TEXT,
  PRIMARY KEY  (userid, moduleid)
)
EOC

register_tablecreate("qotd", <<'EOC');
CREATE TABLE qotd (
  qid           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  time_start    INT UNSIGNED NOT NULL DEFAULT '0',
  time_end      INT UNSIGNED NOT NULL DEFAULT '0',
  active        ENUM('Y','N') NOT NULL DEFAULT 'Y',
  text          TEXT NOT NULL DEFAULT '',
  img_url       VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (qid),
  INDEX (time_start),
  INDEX (time_end)
)
EOC

register_tablecreate("jobstatus", <<'EOC');
CREATE TABLE jobstatus (
  handle VARCHAR(100) PRIMARY KEY,
  result BLOB,
  start_time INT(10) UNSIGNED NOT NULL,
  end_time INT(10) UNSIGNED NOT NULL,
  status ENUM('running', 'success', 'error'),
  KEY (end_time)
)
EOC

register_tablecreate("site_messages", <<'EOC');
CREATE TABLE site_messages (
  mid           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  time_start    INT UNSIGNED NOT NULL DEFAULT '0',
  time_end      INT UNSIGNED NOT NULL DEFAULT '0',
  active        ENUM('Y','N') NOT NULL DEFAULT 'Y',
  text          TEXT NOT NULL DEFAULT '',
  PRIMARY KEY (mid),
  INDEX (time_start),
  INDEX (time_end)
)
EOC

register_tablecreate("expunged_users", <<'EOC');
CREATE TABLE `expunged_users` (
  user varchar(15) NOT NULL default '',
  expunge_time int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (user),
  KEY expunge_time (expunge_time)
)
EOC

register_tablecreate("uniqmap", <<'EOC');
CREATE TABLE uniqmap (
  uniq VARCHAR(15) NOT NULL,
  userid INT UNSIGNED NOT NULL,
  modtime INT UNSIGNED NOT NULL,
  PRIMARY KEY (userid, uniq),
  INDEX(userid, modtime),
  INDEX(uniq, modtime)
)
EOC

register_tablecreate("content_flag", <<'EOC');
CREATE TABLE content_flag (
  flagid INT UNSIGNED NOT NULL AUTO_INCREMENT,
  journalid INT UNSIGNED NOT NULL,
  typeid TINYINT UNSIGNED NOT NULL,
  itemid INT UNSIGNED,
  catid TINYINT UNSIGNED NOT NULL,
  reporterid INT UNSIGNED NOT NULL,
  reporteruniq VARCHAR(15),
  instime INT UNSIGNED NOT NULL,
  modtime INT UNSIGNED NOT NULL,
  status CHAR(1),

  PRIMARY KEY (flagid),
  INDEX (journalid, typeid, itemid),
  INDEX (instime),
  INDEX (reporterid),
  INDEX (status)
)
EOC

# clustered
register_tablecreate("usermsg", <<'EOC');
CREATE TABLE usermsg (
  journalid    INT UNSIGNED NOT NULL,
  msgid        INT UNSIGNED NOT NULL,
  type         ENUM('in','out') NOT NULL,
  parent_msgid INT UNSIGNED,
  otherid      INT UNSIGNED NOT NULL,
  timesent     INT UNSIGNED,
  state        CHAR(1) default 'A',
  PRIMARY KEY  (journalid,msgid),
  INDEX (journalid,type,otherid),
  INDEX (journalid,timesent)
)
EOC

# clustered
register_tablecreate("usermsgtext", <<'EOC');
CREATE TABLE usermsgtext (
  journalid    INT UNSIGNED NOT NULL,
  msgid        INT UNSIGNED NOT NULL,
  subject      VARCHAR(255) BINARY,
  body         BLOB NOT NULL,
  PRIMARY KEY  (journalid,msgid)
)
EOC

# clustered
register_tablecreate("usermsgprop", <<'EOC');
CREATE TABLE usermsgprop (
  journalid    INT UNSIGNED NOT NULL,
  msgid        INT UNSIGNED NOT NULL,
  propid       SMALLINT UNSIGNED NOT NULL,
  propval      VARCHAR(255) NOT NULL,
  PRIMARY KEY (journalid,msgid,propid)
)
EOC

register_tablecreate("usermsgproplist", <<'EOC');
CREATE TABLE usermsgproplist (
  propid  SMALLINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name    VARCHAR(255) DEFAULT NULL,
  des     VARCHAR(255) DEFAULT NULL,
  UNIQUE KEY (name)
)
EOC

# clustered
register_tablecreate("notifyarchive", <<'EOC');
CREATE TABLE notifyarchive (
  userid     INT UNSIGNED NOT NULL,
  qid        INT UNSIGNED NOT NULL,
  createtime INT UNSIGNED NOT NULL,
  journalid  INT UNSIGNED NOT NULL,
  etypeid    SMALLINT UNSIGNED NOT NULL,
  arg1       INT UNSIGNED,
  arg2       INT UNSIGNED,
  state      CHAR(1),
  PRIMARY KEY (userid, qid),
  INDEX       (userid, createtime)
)
EOC

# clustered
register_tablecreate("notifybookmarks", <<'EOC');
CREATE TABLE notifybookmarks (
  userid     INT UNSIGNED NOT NULL,
  qid        INT UNSIGNED NOT NULL,
  PRIMARY KEY  (userid, qid)
)
EOC

# global table for persistent queues
register_tablecreate("persistent_queue", <<'EOC');
CREATE TABLE persistent_queue (
  qkey VARCHAR(255) NOT NULL,
  idx INTEGER UNSIGNED NOT NULL,
  value BLOB,
  PRIMARY KEY (qkey, idx)
)
EOC

# global table for verticals
register_tablecreate("vertical", <<'EOC');
CREATE TABLE vertical (
   vertid INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(255),
   createtime INT UNSIGNED NOT NULL,
   lastfetch INT UNSIGNED,
   # what else ?

   UNIQUE KEY (name)
)
EOC

# FIXME: need vertical_props
# -- blacklists
# -- whitelists
# -- sync info

register_tablecreate("vertical_entries", <<'EOC');
CREATE TABLE vertical_entries (
   vertid INT UNSIGNED NOT NULL,
   instime INT UNSIGNED NOT NULL,
   journalid INT UNSIGNED NOT NULL,
   jitemid INT UNSIGNED NOT NULL,

   PRIMARY KEY (vertid, journalid, jitemid),
   INDEX (vertid, instime)
)
EOC

register_tablecreate("vertical_rules", <<'EOC');
CREATE TABLE vertical_rules (
   vertid INT UNSIGNED NOT NULL,
   rules BLOB,

   PRIMARY KEY (vertid)
)
EOC

register_tablecreate("vertical_editorials", <<'EOC');
CREATE TABLE vertical_editorials (
  edid          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  vertid        INT UNSIGNED NOT NULL DEFAULT '0',
  adminid       INT UNSIGNED NOT NULL DEFAULT '0',
  time_start    INT UNSIGNED NOT NULL DEFAULT '0',
  time_end      INT UNSIGNED NOT NULL DEFAULT '0',
  title         VARCHAR(255) NOT NULL DEFAULT '',
  editor        VARCHAR(255) DEFAULT NULL,
  img_url       TEXT DEFAULT NULL,
  submitter     VARCHAR(255) DEFAULT NULL,
  block_1_title VARCHAR(255) NOT NULL DEFAULT '',
  block_1_text  TEXT NOT NULL DEFAULT '',
  block_2_title VARCHAR(255) DEFAULT NULL,
  block_2_text  TEXT DEFAULT NULL,
  block_3_title VARCHAR(255) DEFAULT NULL,
  block_3_text  TEXT DEFAULT NULL,
  block_4_title VARCHAR(255) DEFAULT NULL,
  block_4_text  TEXT DEFAULT NULL,
  PRIMARY KEY (edid),
  INDEX (vertid),
  INDEX (time_start),
  INDEX (time_end)
)
EOC

## --
## -- embedconten previews
## --
register_tablecreate("embedcontent_preview", <<'EOC');
CREATE TABLE embedcontent_preview (
  userid int(10) unsigned NOT NULL default '0',
  moduleid int(10) NOT NULL default '0',
  content text,
  PRIMARY KEY  (userid,moduleid)
) TYPE=InnoDB
EOC


# NOTE: new table declarations go here

register_tablecreate("logprop_history", <<'EOC');
CREATE TABLE logprop_history (
  journalid  INT UNSIGNED NOT NULL,
  jitemid    MEDIUMINT UNSIGNED NOT NULL,
  propid     TINYINT unsigned NOT NULL,
  change_time  INT UNSIGNED NOT NULL DEFAULT '0',
  old_value  VARCHAR(255) default NULL,
  new_value  VARCHAR(255) default NULL,
  note       VARCHAR(255) default NULL,
  INDEX (journalid,jitemid,propid)
)
EOC

register_tablecreate("sch_mass_funcmap", <<'EOC');
CREATE TABLE sch_mass_funcmap (
        funcid         INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
        funcname       VARCHAR(255) NOT NULL,
        UNIQUE(funcname)
)
EOC

register_tablecreate("sch_mass_job", <<'EOC');
CREATE TABLE sch_mass_job (
        jobid           BIGINT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
        funcid          INT UNSIGNED NOT NULL,
        arg             MEDIUMBLOB,
        uniqkey         VARCHAR(255) NULL,
        insert_time     INTEGER UNSIGNED,
        run_after       INTEGER UNSIGNED NOT NULL,
        grabbed_until   INTEGER UNSIGNED,
        priority        SMALLINT UNSIGNED,
        coalesce        VARCHAR(255),
        INDEX (funcid, run_after),
        UNIQUE(funcid, uniqkey),
        INDEX (funcid, coalesce)
)
EOC

register_tablecreate("sch_mass_note", <<'EOC');
CREATE TABLE sch_mass_note (
        jobid           BIGINT UNSIGNED NOT NULL,
        notekey         VARCHAR(255),
        PRIMARY KEY (jobid, notekey),
        value           MEDIUMBLOB
)
EOC

register_tablecreate("sch_mass_error", <<'EOC');
CREATE TABLE sch_mass_error (
        error_time      INTEGER UNSIGNED NOT NULL,
        jobid           BIGINT UNSIGNED NOT NULL,
        message         VARCHAR(255) NOT NULL,
        INDEX (error_time),
        INDEX (jobid)
)
EOC

register_tablecreate("sch_mass_exitstatus", <<'EOC');
CREATE TABLE sch_mass_exitstatus (
        jobid           BIGINT UNSIGNED PRIMARY KEY NOT NULL,
        status          SMALLINT UNSIGNED,
        completion_time INTEGER UNSIGNED,
        delete_after    INTEGER UNSIGNED,
        INDEX (delete_after)
)
EOC

# global table for community directory
register_tablecreate("category", <<'EOC');
CREATE TABLE category (
   catid       INT UNSIGNED NOT NULL AUTO_INCREMENT,
   pretty_name VARCHAR(255) NOT NULL,
   url_path    VARCHAR(120) NOT NULL,
   parentcatid INT UNSIGNED,
   PRIMARY KEY (catid),
   INDEX       (url_path),
   INDEX       (parentcatid)
)
EOC

# Map journals to categories
register_tablecreate("categoryjournals", <<'EOC');
CREATE TABLE categoryjournals (
   catid     INT UNSIGNED NOT NULL,
   journalid INT UNSIGNED NOT NULL,
   PRIMARY KEY (catid, journalid),
   INDEX       (journalid)
)
EOC

# Extra properties for categories
register_tablecreate("categoryprop", <<'EOC');
CREATE TABLE categoryprop (
   catid     INT UNSIGNED NOT NULL,
   propid    SMALLINT UNSIGNED NOT NULL,
   propval   VARCHAR(255) NOT NULL,
   INDEX     (catid, propid)
)
EOC

# Property list for categories
register_tablecreate("categoryproplist", <<'EOC');
CREATE TABLE categoryproplist (
  propid SMALLINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name   VARCHAR(255) DEFAULT NULL,
  des    VARCHAR(255) DEFAULT NULL,
  scope  ENUM('general', 'local') DEFAULT 'general' NOT NULL,
  UNIQUE KEY (name)
)
EOC

# Moderation of submissions for Community Directory
register_tablecreate("categoryjournals_pending", <<'EOC');
CREATE TABLE categoryjournals_pending (
  `pendid`   int unsigned NOT NULL auto_increment,
  `jid`      int unsigned NOT NULL default '0',
  `submitid` int unsigned,
  `catid`    int unsigned NOT NULL,
  `status`   CHAR(1),
  `lastupdate` int(10) unsigned NOT NULL,
  `modid`      int unsigned,
  PRIMARY KEY (`pendid`),
  KEY `jid` (`jid`),
  KEY `catid` (`catid`)
)
EOC

register_tablecreate("comet_history", <<'EOC');
CREATE TABLE comet_history (
     rec_id   INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
     uid      INT(10) UNSIGNED NOT NULL,
     type     VARCHAR(31),
     message  TEXT,
     added    DATETIME,
     INDEX(uid)
)
EOC

register_tablecreate("antispam", <<'EOC');
CREATE TABLE antispam (
    journalid INT(10) UNSIGNED NOT NULL,
    itemid INT(10) unsigned NOT NULL default 0,
    type CHAR(1) NOT NULL,
    posterid INT(10) UNSIGNED NOT NULL default 0,
    eventtime DATETIME default NULL,
    poster_ip CHAR(15),
    email CHAR(50) default NULL,
    user_agent VARCHAR(128),
    uniq CHAR(15),
    spam TINYINT UNSIGNED,
    confidence FLOAT(4,3) UNSIGNED,
    review CHAR(1),
    PRIMARY KEY (journalid, itemid, type),
    INDEX (posterid, eventtime),
    INDEX (spam),
    INDEX (review)
)
EOC

### changes

register_alter(sub {

    my $dbh = shift;
    my $runsql = shift;

    if (column_type("content_flag", "reporteruniq") eq "")
    {
        do_alter("content_flag",
                 "ALTER TABLE content_flag ADD reporteruniq VARCHAR(15) AFTER reporterid");

    }
    if (column_type("supportcat", "is_selectable") eq "")
    {
        do_alter("supportcat",
                 "ALTER TABLE supportcat ADD is_selectable ENUM('1','0') ".
                 "NOT NULL DEFAULT '1', ADD public_read  ENUM('1','0') NOT ".
                 "NULL DEFAULT '1', ADD public_help ENUM('1','0') NOT NULL ".
                 "DEFAULT '1', ADD allow_screened ENUM('1','0') NOT NULL ".
                 "DEFAULT '0', ADD replyaddress VARCHAR(50), ADD hide_helpers ".
                 "ENUM('1','0') NOT NULL DEFAULT '0' AFTER allow_screened");

    }
    if (column_type("supportlog", "type") =~ /faqref/)
    {
        do_alter("supportlog",
                 "ALTER TABLE supportlog MODIFY type ENUM('req', 'answer', ".
                 "'custom', 'faqref', 'comment', 'internal', 'screened') ".
                 "NOT NULL");
        do_sql("UPDATE supportlog SET type='answer' WHERE type='custom'");
        do_sql("UPDATE supportlog SET type='answer' WHERE type='faqref'");
        do_alter("supportlog",
                 "ALTER TABLE supportlog MODIFY type ENUM('req', 'answer', ".
                 "'comment', 'internal', 'screened') NOT NULL");

    }
    if (table_relevant("supportcat") && column_type("supportcat", "catkey") eq "")
    {
        do_alter("supportcat",
                 "ALTER TABLE supportcat ADD catkey VARCHAR(25) AFTER spcatid");
        do_sql("UPDATE supportcat SET catkey=spcatid WHERE catkey IS NULL");
        do_alter("supportcat",
                 "ALTER TABLE supportcat MODIFY catkey VARCHAR(25) NOT NULL");
    }
    if (column_type("supportcat", "no_autoreply") eq "")
    {
        do_alter("supportcat",
                 "ALTER TABLE supportcat ADD no_autoreply ENUM('1', '0') ".
                 "NOT NULL DEFAULT '0'");
    }

    if (column_type("support", "timelasthelp") eq "")
    {
        do_alter("supportlog",
                 "ALTER TABLE supportlog ADD INDEX (userid)");
        do_alter("support",
                 "ALTER TABLE support ADD timelasthelp INT UNSIGNED");
    }

    if (column_type("duplock", "realm") !~ /payments/)
    {
        do_alter("duplock",
                 "ALTER TABLE duplock MODIFY realm ENUM('support','log',".
                 "'comment','payments') NOT NULL default 'support'");
    }

    if (column_type("schematables", "redist_where") eq "")
    {
        do_alter("schematables",
                 "ALTER TABLE schematables ADD ".
                 "redist_where varchar(255) AFTER redist_mode");
    }

    # upgrade people to the new capabilities system.  if they're
    # using the the paidfeatures column already, we'll assign them
    # the same capability bits that ljcom will be using.
    if (table_relevant("user") && column_type("user", "caps") eq "")
    {
        do_alter("user",
                 "ALTER TABLE user ADD ".
                 "caps SMALLINT UNSIGNED NOT NULL DEFAULT 0 AFTER user");
        try_sql("UPDATE user SET caps=16|8|2 WHERE paidfeatures='on'");
        try_sql("UPDATE user SET caps=8|2    WHERE paidfeatures='paid'");
        try_sql("UPDATE user SET caps=4|2    WHERE paidfeatures='early'");
        try_sql("UPDATE user SET caps=2      WHERE paidfeatures='off'");
    }

    # axe this column (and its two related ones) if it exists.
    if (column_type("user", "paidfeatures"))
    {
        try_sql("REPLACE INTO paiduser (userid, paiduntil, paidreminder) ".
                "SELECT userid, paiduntil, paidreminder FROM user WHERE paidfeatures='paid'");
        try_sql("REPLACE INTO paiduser (userid, paiduntil, paidreminder) ".
                "SELECT userid, COALESCE(paiduntil,'0000-00-00'), NULL FROM user WHERE paidfeatures='on'");
        do_alter("user",
                 "ALTER TABLE user DROP paidfeatures, DROP paiduntil, DROP paidreminder");
    }

    # move S1 _style ids to userprop table!
    if (column_type("user", "lastn_style")) {

        # be paranoid and insert these in case they don't exist:
        try_sql("INSERT INTO userproplist VALUES (null, 's1_lastn_style', 0, 'Recent View StyleID', 'num', 'The style ID# of the S1 style for the recent entries view.')");
        try_sql("INSERT INTO userproplist VALUES (null, 's1_calendar_style', 0, 'Calendar View StyleID', 'num', 'The style ID# of the S1 style for the calendar view.')");
        try_sql("INSERT INTO userproplist VALUES (null, 's1_day_style', 0, 'Day View StyleID', 'num', 'The style ID# of the S1 style for the day view.')");
        try_sql("INSERT INTO userproplist VALUES (null, 's1_friends_style', 0, 'Friends View StyleID', 'num', 'The style ID# of the S1 style for the friends view.')");

        foreach my $v (qw(lastn day calendar friends)) {
            do_sql("INSERT INTO userproplite SELECT u.userid, upl.upropid, u.${v}_style FROM user u, userproplist upl WHERE upl.name='s1_${v}_style'");
        }

        do_alter("user",
                 "ALTER TABLE user DROP lastn_style, DROP calendar_style, DROP search_style, DROP searchres_style, DROP day_style, DROP friends_style");
    }

    # add scope columns to proplist tables
    if (column_type("userproplist", "scope") eq "") {
        do_alter("userproplist",
                 "ALTER TABLE userproplist ADD scope ENUM('general', 'local') ".
                 "DEFAULT 'general' NOT NULL");
    }

    if (column_type("logproplist", "scope") eq "") {
        do_alter("logproplist",
                 "ALTER TABLE logproplist ADD scope ENUM('general', 'local') ".
                 "DEFAULT 'general' NOT NULL");
    }

    if (column_type("talkproplist", "scope") eq "") {
        do_alter("talkproplist",
                 "ALTER TABLE talkproplist ADD scope ENUM('general', 'local') ".
                 "DEFAULT 'general' NOT NULL");
    }

    if (column_type("priv_list", "scope") eq "") {
        do_alter("priv_list",
                 "ALTER TABLE priv_list ADD scope ENUM('general', 'local') ".
                 "DEFAULT 'general' NOT NULL");
    }

    # change size of stats table to accomodate meme data, and shrink statcat,
    # since it's way too big
    if (column_type("stats", "statcat") eq "varchar(100)") {
        do_alter("stats",
                 "ALTER TABLE stats ".
                 "MODIFY statcat VARCHAR(30) NOT NULL, ".
                 "MODIFY statkey VARCHAR(150) NOT NULL, ".
                 "MODIFY statval INT UNSIGNED NOT NULL, ".
                 "DROP INDEX statcat");
    }

    if (column_type("priv_list", "is_public") eq "") {
        do_alter("priv_list",
                 "ALTER TABLE priv_list ".
                 "ADD is_public ENUM('1', '0') DEFAULT '1' NOT NULL");
    }

    # cluster stuff!
    if (column_type("meme", "journalid") eq "") {
        do_alter("meme",
                 "ALTER TABLE meme ADD journalid INT UNSIGNED NOT NULL AFTER ts");
    }

    if (column_type("memorable", "jitemid") eq "") {
        do_alter("memorable", "ALTER TABLE memorable ".
                 "DROP INDEX userid, DROP INDEX itemid, ".
                 "CHANGE itemid jitemid INT UNSIGNED NOT NULL, ".
                 "ADD journalid INT UNSIGNED NOT NULL AFTER userid, ".
                 "ADD UNIQUE uniq (userid, journalid, jitemid), ".
                 "ADD KEY item (journalid, jitemid)");
    }

    if (column_type("user", "clusterid") eq "") {
        do_alter("user", "ALTER TABLE user ".
                 "ADD clusterid TINYINT UNSIGNED NOT NULL AFTER caps, ".
                 "ADD dversion TINYINT UNSIGNED NOT NULL AFTER clusterid, ".
                 "ADD INDEX idxcluster (clusterid), ".
                 "ADD INDEX idxversion (dversion)");
    }

    if (column_type("friends", "bgcolor") eq "char(7)") {
        do_alter("friends", "ALTER TABLE friends ".
                 "MODIFY bgcolor CHAR(8) NOT NULL DEFAULT '16777215', ".
                 "MODIFY fgcolor CHAR(8) NOT NULL DEFAULT '0'");
        do_sql("UPDATE friends SET ".
               "bgcolor=CONV(RIGHT(bgcolor,6),16,10), ".
               "fgcolor=CONV(RIGHT(fgcolor,6),16,10)")
            unless skip_opt() eq "colorconv";
    }

    return if skip_opt() eq "colorconv";

    if (column_type("friends", "bgcolor") eq "char(8)") {
        do_alter("friends", "ALTER TABLE friends ".
                 "MODIFY bgcolor MEDIUMINT UNSIGNED NOT NULL DEFAULT 16777215, ".
                 "MODIFY fgcolor MEDIUMINT UNSIGNED NOT NULL DEFAULT 0");
    }

    # add the default encoding field, for recoding older pre-Unicode stuff

    if (column_type("user", "oldenc") eq "") {
        do_alter("user", "ALTER TABLE user ".
                 "ADD oldenc TINYINT DEFAULT 0 NOT NULL, ".
                 "MODIFY name CHAR(80) NOT NULL");
    }

    if (column_type("user", "allow_getpromos") ne "") {
        do_alter("user", "ALTER TABLE user DROP allow_getpromos");
    }

    # widen columns to accomodate larger Unicode names
    if (column_type("friendgroup", "groupname") eq "varchar(30)") {
        do_alter("friendgroup",
                 "ALTER TABLE friendgroup ".
                 "MODIFY groupname VARCHAR(60) NOT NULL");
    }
    if (column_type("todo", "statusline") eq "varchar(15)") {
        do_alter("todo",
                 "ALTER TABLE todo ".
                 "MODIFY statusline VARCHAR(40) NOT NULL, " .
                 "MODIFY subject VARCHAR(100) NOT NULL, " .
                 "MODIFY des VARCHAR(255) NOT NULL");
    }
    if (column_type("memorable", "des") eq "varchar(60)") {
        do_alter("memorable",
                 "ALTER TABLE memorable ".
                 "MODIFY des VARCHAR(150) NOT NULL");
    }
    if (column_type("keywords", "keyword") eq "varchar(40) binary") {
        do_alter("keywords",
                 "ALTER TABLE keywords ".
                 "MODIFY keyword VARCHAR(80) BINARY NOT NULL");
    }

    # change interest.interest key to being unique, if it's not already
    {
        my $sth = $dbh->prepare("SHOW INDEX FROM interests");
        $sth->execute;
        while (my $i = $sth->fetchrow_hashref) {
            if ($i->{'Key_name'} eq "interest" && $i->{'Non_unique'}) {
                do_alter("interests", "ALTER IGNORE TABLE interests ".
                         "DROP INDEX interest, ADD UNIQUE interest (interest)");
                last;
            }
        }
    }

    if (column_type("supportcat", "scope") eq "")
    {
        do_alter("supportcat",
                 "ALTER IGNORE TABLE supportcat ADD scope ENUM('general', 'local') ".
                 "NOT NULL DEFAULT 'general', ADD UNIQUE (catkey)");
    }

    # convert 'all' arguments to '*'
    if (table_relevant("priv_map") && !check_dbnote("privcode_all_to_*")) {

        # arg isn't keyed, but this table is only a couple thousand rows
        do_sql("UPDATE priv_map SET arg='*' WHERE arg='all'");

        set_dbnote("privcode_all_to_*", 1);
    }

    # convert 'wizard' s2 styles to 'wizard-uniq'
    if (table_relevant("s2styles") && !check_dbnote("s2style-wizard-update")) {

        # set_dbnote will return true if $opt_sql is set and it sets
        # the note successfully.  only then do we run the wizard updater
        set_dbnote("s2style-wizard-update", 1) &&
            system("$ENV{'LJHOME'}/bin/upgrading/s2style-wizard-update.pl");
    }

    # this never ended up being useful, and just freaked people out unnecessarily.
    if (column_type("user", "track")) {
        do_alter("user", "ALTER TABLE user DROP track");
    }

    # need more choices (like "Y" for sYndicated journals)
    if (column_type("user", "journaltype") =~ /enum/i) {
        do_alter("user", "ALTER TABLE user MODIFY journaltype CHAR(1) NOT NULL DEFAULT 'P'");
    }

    unless (column_type("syndicated", "laststatus")) {
        do_alter("syndicated",
                 "ALTER TABLE syndicated ADD laststatus VARCHAR(80), ADD lastnew DATETIME");
    }

    # change themedata. key to being unique, if it's not already
    unless (index_name("themedata", "UNIQUE:themeid-coltype")) {
        do_alter("themedata", "ALTER IGNORE TABLE themedata ".
                 "DROP KEY themeid, MODIFY coltype VARCHAR(30) NOT NULL, ".
                 "ADD UNIQUE `thuniq` (themeid, coltype)");
    }

    unless (column_type("syndicated", "numreaders")) {
        do_alter("syndicated",
                 "ALTER TABLE syndicated ".
                 "ADD numreaders MEDIUMINT, ADD INDEX (numreaders)");
    }

    if (column_type("community", "ownerid"))
    {
        do_alter("community",
                 "ALTER TABLE community DROP ownerid");
    }

    # if it exists, but it's the old way, just kill it.
    if (column_type("weekuserusage", "ubefore") && ! column_type("weekuserusage", "uafter")) {
        do_sql("DROP TABLE weekuserusage");
        create_table("weekuserusage");
    }

    unless (column_type("userproplist", "cldversion")) {
        do_alter("userproplist",
                 "ALTER TABLE userproplist ADD cldversion TINYINT UNSIGNED NOT NULL AFTER indexed");
    }

    unless (column_type("authactions", "used") &&
            index_name("authactions", "INDEX:userid") &&
            index_name("authactions", "INDEX:datecreate")) {

        do_alter("authactions",
                 "ALTER TABLE authactions " .
                 "ADD used enum('Y', 'N') DEFAULT 'N' AFTER arg1, " .
                 "ADD INDEX(userid), ADD INDEX(datecreate)");
    }

    unless (column_type("s2styles", "modtime")) {
        do_alter("s2styles",
                 "ALTER TABLE s2styles ADD modtime INT UNSIGNED NOT NULL AFTER name");
    }

    if (column_type("acctinvite", "reason") eq "varchar(20)") {
        do_alter("acctinvite",
                 "ALTER TABLE acctinvite MODIFY reason VARCHAR(40)");
    }

    # Add BLOB flag to proplist
    unless (column_type("userproplist", "datatype") =~ /blobchar/) {
        if (column_type("userproplist", "is_blob")) {
            do_alter("userproplist",
                     "ALTER TABLE userproplist DROP is_blob");
        }
        do_alter("userproplist",
                 "ALTER TABLE userproplist MODIFY datatype ENUM('char','num','bool','blobchar') NOT NULL DEFAULT 'char'");
    }

    if (column_type("challenges", "count") eq "")
    {
        do_alter("challenges",
                 "ALTER TABLE challenges ADD ".
                 "count int(5) UNSIGNED NOT NULL DEFAULT 0 AFTER challenge");
    }

    if (column_type("userblob", "length") =~ /mediumint/)
    {
        do_alter("userblob", "ALTER TABLE userblob MODIFY length INT UNSIGNED");
    }

    unless (index_name("support", "INDEX:requserid")) {
        do_alter("support", "ALTER IGNORE TABLE support ADD INDEX (requserid), ADD INDEX (reqemail)");
    }

    unless (column_type("community", "membership") =~ /moderated/i) {
        do_alter("community", "ALTER TABLE community MODIFY COLUMN " .
                 "membership ENUM('open','closed','moderated') DEFAULT 'open' NOT NULL");
    }

    if (column_type("userproplist", "multihomed") eq '') {
        do_alter("userproplist", "ALTER TABLE userproplist " .
                 "ADD multihomed ENUM('1', '0') NOT NULL DEFAULT '0' AFTER cldversion");
    }

    if (index_name("moodthemedata", "INDEX:moodthemeid")) {
        do_alter("moodthemedata", "ALTER IGNORE TABLE moodthemedata DROP KEY moodthemeid");
    }

    if (column_type("userpic2", "flags") eq '') {
        do_alter("userpic2", "ALTER TABLE userpic2 " .
                 "ADD flags tinyint(1) unsigned NOT NULL default 0 AFTER comment, " .
                 "ADD location enum('blob','disk','mogile') default NULL AFTER flags");
    }

    if (column_type("userblob", "blobid") =~ /mediumint/) {
        do_alter("userblob", "ALTER TABLE userblob MODIFY blobid INT UNSIGNED NOT NULL");
    }

    if (column_type("counter", "max") =~ /mediumint/) {
        do_alter("counter", "ALTER TABLE counter MODIFY max INT UNSIGNED NOT NULL DEFAULT 0");
    }

    if (column_type("userpic2", "url") eq '') {
        do_alter("userpic2", "ALTER TABLE userpic2 " .
                 "ADD url VARCHAR(255) default NULL AFTER location");
    }

    unless (column_type("spamreports", "posttime") ne '') {
        do_alter("spamreports", "ALTER TABLE spamreports ADD COLUMN posttime INT(10) UNSIGNED " .
                 "NOT NULL AFTER reporttime, ADD COLUMN state ENUM('open', 'closed') DEFAULT 'open' " .
                 "NOT NULL AFTER posttime");
    }

    if (column_type("captchas", "location") eq '') {
        do_alter("captchas", "ALTER TABLE captchas " .
                 "ADD location ENUM('blob','mogile') DEFAULT NULL AFTER type");
    }

    if (column_type("spamreports", "report_type") eq '') {
        do_alter("spamreports", "ALTER TABLE spamreports " .
                "ADD report_type ENUM('entry','comment') NOT NULL DEFAULT 'comment' " .
                "AFTER posterid");
    }

    if (column_type("commenturls", "ip") eq '') {
        do_alter("commenturls",
                "ALTER TABLE commenturls " .
                "ADD ip VARCHAR(15) DEFAULT NULL " .
                "AFTER journalid");
    }

    if (column_type("sessions", "exptype") !~ /once/) {
        do_alter("sessions",
                "ALTER TABLE sessions CHANGE COLUMN exptype ".
                "exptype ENUM('short', 'long', 'once') NOT NULL");
    }

    if (column_type("ml_items", "itid") =~ /auto_increment/) {
        do_alter("ml_items",
                "ALTER TABLE ml_items MODIFY COLUMN " .
                "itid MEDIUMINT UNSIGNED NOT NULL DEFAULT 0");
    }

    if (column_type("ml_text", "txtid") =~ /auto_increment/) {
        do_alter("ml_text",
                "ALTER TABLE ml_text MODIFY COLUMN " .
                "txtid MEDIUMINT UNSIGNED NOT NULL DEFAULT 0");
    }

    unless (column_type("syndicated", "oldest_ourdate")) {
        do_alter("syndicated",
                 "ALTER TABLE syndicated ADD oldest_ourdate DATETIME AFTER lastnew");
    }

    if (column_type("sessions", "userid") =~ /mediumint/) {
        do_alter("sessions",
                "ALTER TABLE sessions MODIFY COLUMN userid INT UNSIGNED NOT NULL");
    }

    if (column_type("faq", "summary") eq '') {
        do_alter("faq",
                 "ALTER TABLE faq ADD summary TEXT AFTER question");
    }
    
    if (!column_type("faq", "uses")) {
        do_alter("faq",
                 "ALTER TABLE faq ADD uses int(11) NOT NULL default 0");
    }


    if (column_type("spamreports", "srid") eq '') {
        do_alter("spamreports",
                 "ALTER TABLE spamreports DROP PRIMARY KEY");

        do_alter("spamreports",
                 "ALTER TABLE spamreports ADD srid MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT FIRST");

        do_alter("spamreports",
                 "ALTER TABLE spamreports ADD INDEX (reporttime, journalid)");
    }

    if (column_type("includetext", "inctext") !~ /mediumtext/) {
        do_alter("includetext",
                 "ALTER TABLE includetext MODIFY COLUMN inctext MEDIUMTEXT");
    }
    if (column_type("portal_config", "userid") !~ /unsigned/i) {
        do_alter("portal_config",
                 "ALTER TABLE portal_config MODIFY COLUMN userid INT UNSIGNED NOT NULL, MODIFY COLUMN pboxid SMALLINT UNSIGNED NOT NULL, MODIFY COLUMN sortorder SMALLINT UNSIGNED NOT NULL, MODIFY COLUMN type INT UNSIGNED NOT NULL");
    }
    if (column_type("portal_box_prop", "userid") !~ /unsigned/i) {
                 do_alter("portal_box_prop",
                          "ALTER TABLE portal_box_prop MODIFY COLUMN userid INT UNSIGNED NOT NULL, MODIFY COLUMN pboxid SMALLINT UNSIGNED NOT NULL, MODIFY COLUMN ppropid SMALLINT UNSIGNED NOT NULL");
    }

    # These table are both livejournal tables, although could have ljcom values
    # that we need to update.  Not trying to be lazy, but running the updates in
    # update-db-local.pl would cause us to have to do a select on the table everytime
    # to see if it still has old values, which is lame.  The updates also can't run
    # before the alter so and if on if the alter has happened also isn't really
    # useful.  So here they live. :-\
    foreach my $table (qw(recentactions actionhistory)) {

        if (column_type($table, "what") =~ /^char/i) {
            do_alter($table,
                     "ALTER TABLE $table MODIFY COLUMN what VARCHAR(20) NOT NULL");

            next if $table eq 'recentactions';

            # Since actionhistory is updated nightly, is alright to do updates now
            do_sql("UPDATE actionhistory SET what='post' WHERE what='P'");
            do_sql("UPDATE actionhistory SET what='phonepost' WHERE what='_F'");
            do_sql("UPDATE actionhistory SET what='phonepost_mp3' WHERE what='_M'");
        }
    }

    # table format totally changed, we'll just truncate and modify
    # all of the columns since the data is just summary anyway
    if (index_name("active_user", "INDEX:time")) {
        do_sql("TRUNCATE TABLE active_user");
        do_alter("active_user",
                 "ALTER TABLE active_user " .
                 "DROP time, DROP KEY userid, " .
                 "ADD year SMALLINT NOT NULL FIRST, " .
                 "ADD month TINYINT NOT NULL AFTER year, " .
                 "ADD day TINYINT NOT NULL AFTER month, " .
                 "ADD hour TINYINT NOT NULL AFTER day, " .
                 "ADD PRIMARY KEY (year, month, day, hour, userid)");
    }

    if (index_name("active_user_summary", "UNIQUE:year-month-day-hour-clusterid-type")) {
        do_alter("active_user_summary",
                 "ALTER TABLE active_user_summary DROP PRIMARY KEY, " .
                 "ADD INDEX (year, month, day, hour)");
    }

    if (column_type("blobcache", "bckey") =~ /40/) {
        do_alter("blobcache",
                 "ALTER TABLE blobcache MODIFY bckey VARCHAR(255) NOT NULL");
    }

    if (column_type("eventtypelist", "eventtypeid")) {
        do_alter("eventtypelist",
                 "ALTER TABLE eventtypelist CHANGE eventtypeid etypeid SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT");
    }

    unless (column_type("sms_msg", "status")) {
        do_alter("sms_msg",
                 "ALTER TABLE sms_msg ADD status ENUM('success', 'error', 'unknown') NOT NULL DEFAULT 'unknown' AFTER type");
    }

    unless (column_type("sms_msg", "status") =~ /ack_wait/) {
        do_alter("sms_msg",
                 "ALTER TABLE sms_msg MODIFY status ENUM('success', 'error', 'ack_wait', 'unknown') NOT NULL DEFAULT 'unknown'");
    }

    if (column_type("sms_msg", "msg_raw")) {
        do_alter("sms_msg",
                 "ALTER TABLE sms_msg DROP msg_raw");
    }

    # add index on journalid, etypeid to subs
    unless (index_name("subs", "INDEX:etypeid-journalid") || index_name("subs", "INDEX:etypeid-journalid-userid")) {
        # This one is deprecated by the one below, which adds a userid
        # at the end.  hence the double if above.
        do_alter("subs", "ALTER TABLE subs ".
                 "ADD INDEX (etypeid, journalid)");
    }

    unless (column_type("sch_error", "funcid")) {
        do_alter("sch_error", "alter table sch_error add funcid int(10) unsigned NOT NULL default 0, add index (funcid, error_time)");
    }

    unless (column_type("sch_exitstatus", "funcid")) {
        do_alter("sch_exitstatus", "alter table sch_exitstatus add funcid INT UNSIGNED NOT NULL DEFAULT 0, add index (funcid)");
    }

    # make userid unique
    if (index_name("smsusermap", "INDEX:userid")) {
        # iterate over the table and delete dupes
        my $sth = $dbh->prepare("SELECT userid, number FROM smsusermap");
        $sth->execute();

        my %map = ();
        while (my $row = $sth->fetchrow_hashref) {
            my $uid = $row->{userid};
            my $num = $row->{number};

            if ($map{$uid}) {
                # dupe, delete
                $dbh->do("DELETE FROM smsusermap WHERE userid=? AND number=?",
                         undef, $uid, $num);
            }

            $map{$uid} = 1;
        }

        do_alter("smsusermap", "ALTER IGNORE TABLE smsusermap ".
                 "DROP KEY userid, ADD UNIQUE (userid)");
    }

    # add index to sms_msg
    unless (index_name("sms_msg", "INDEX:userid-timecreate")) {
        do_alter("sms_msg", "ALTER TABLE sms_msg ADD INDEX(userid, timecreate)");
    }

    # add typekey to sms_msg
    unless (column_type("sms_msg", "class_key")) {
        do_alter("sms_msg", "ALTER TABLE sms_msg " .
                 "ADD class_key VARCHAR(25) NOT NULL default 'unknown' AFTER timecreate");
    }

    # add index on just timecreate for time-bound stats
    unless (index_name("sms_msg", "INDEX:timecreate")) {
        do_alter("sms_msg", "ALTER TABLE sms_msg ADD INDEX(timecreate)");
    }

    # add verified/instime columns to smsusermap
    unless (column_type("smsusermap", "verified")) {
        do_alter("smsusermap", "ALTER TABLE smsusermap " .
                 "ADD verified ENUM('Y','N') NOT NULL DEFAULT 'N', " .
                 "ADD instime INT UNSIGNED NOT NULL");
    }

    # add an index
    unless (index_name("subs", "INDEX:etypeid-journalid-userid")) {
        do_alter("subs",
                 "ALTER TABLE subs DROP INDEX etypeid, ADD INDEX etypeid (etypeid, journalid, userid)");
    }

    # add a column
    unless (column_type("qotd", "tags")) {
        do_alter("qotd",
                 "ALTER TABLE qotd ADD tags VARCHAR(255) DEFAULT NULL AFTER text");
    }

    # fix primary key
    unless (index_name("pollresult2", "UNIQUE:journalid-pollid-pollqid-userid")) {
        do_alter("pollresult2",
                 "ALTER TABLE pollresult2 DROP PRIMARY KEY, ADD PRIMARY KEY (journalid,pollid,pollqid,userid)");
    }

    # fix primary key
    unless (index_name("pollsubmission2", "UNIQUE:journalid-pollid-userid")) {
        do_alter("pollsubmission2",
                 "ALTER TABLE pollsubmission2 DROP PRIMARY KEY, ADD PRIMARY KEY (journalid,pollid,userid)");
    }

    # add an indexed 'userid' column
    unless (column_type("expunged_users", "userid")) {
        do_alter("expunged_users",
                 "ALTER TABLE expunged_users ADD userid INT UNSIGNED NOT NULL FIRST, " .
                 "ADD INDEX (userid)");
    }

    # add a column
    unless (column_type("qotd", "extra_text")) {
        do_alter("qotd",
                 "ALTER TABLE qotd ADD extra_text TEXT DEFAULT NULL");
    }

    # add a column
    unless (column_type("qotd", "subject")) {
        do_alter("qotd",
                 "ALTER TABLE qotd " .
                 "ADD subject VARCHAR(255) NOT NULL DEFAULT '' AFTER active, " .
                 "ADD from_user CHAR(15) DEFAULT NULL AFTER tags");
    }

    unless (column_type("usermsgproplist", "scope")) {
        do_alter("usermsgproplist",
                 "ALTER TABLE usermsgproplist ADD scope ENUM('general', 'local') "
                 . "DEFAULT 'general' NOT NULL");
    }

    unless (column_type("qotd", "cap_mask")) {
        do_alter("qotd",
                 "ALTER TABLE qotd " .
                 # bitmask representation of cap classes that this question applies to
                 "ADD cap_mask SMALLINT UNSIGNED NOT NULL, " .
                 # show to logged out users or not
                 "ADD show_logged_out ENUM('Y','N') NOT NULL DEFAULT 'N', " .
                 "ADD countries VARCHAR(255)");

        # set all current questions to be shown to all classes and logged out users
        if (table_relevant("qotd")) {
            my $mask = LJ::mask_from_bits(keys %LJ::CAP);
            do_sql("UPDATE qotd SET cap_mask=$mask, show_logged_out='Y'");
        }
    }

    unless (column_type("qotd", "link_url")) {
        do_alter("qotd",
                 "ALTER TABLE qotd " .
                 "ADD link_url VARCHAR(255) NOT NULL DEFAULT ''");
    }

    if (table_relevant("spamreports") && column_type("spamreports", "report_type") !~ /message/) {
        # cache table by running select
        do_sql("SELECT COUNT(*) FROM spamreports");
        # add 'message' enum
        do_alter("spamreports", "ALTER TABLE spamreports " .
                 "CHANGE COLUMN report_type report_type " .
                 "ENUM('entry','comment','message') NOT NULL DEFAULT 'comment'");
    }

    if (column_type("supportcat", "user_closeable") eq "") {
        do_alter("supportcat",
                 "ALTER TABLE supportcat ADD " .
                 "user_closeable ENUM('1', '0') NOT NULL DEFAULT '1' " .
                 "AFTER hide_helpers");
    }

    unless (column_type("content_flag", "supportid")) {
        do_alter("content_flag",
                 "ALTER TABLE content_flag " .
                 "ADD supportid INT(10) UNSIGNED NOT NULL DEFAULT '0'");
    }

    if (keys %LJ::VERTICAL_TREE && table_relevant("vertical")) {
        my @vertical_names = keys %LJ::VERTICAL_TREE;


        # get all of the verticals currently in the db
        my $verts = $dbh->selectcol_arrayref("SELECT name FROM vertical");


        # remove any verticals from the db that aren't in the config hash
        my @verts_to_remove;
        foreach my $name (@$verts) {
            push @verts_to_remove, $name unless $LJ::VERTICAL_TREE{$name};
        }

        if (@verts_to_remove) {
            my @string_verts = map { "'$_'" } @verts_to_remove;
            my $vert_sql = join(',', @string_verts);
            do_sql("DELETE FROM vertical WHERE name IN ($vert_sql)");
        }


        # add any verticals to the db that are in the config hash (and aren't there already)
        my %verts_in_db = map { $_ => 1 } @$verts;

        my %verts_to_add;
        foreach my $name (@vertical_names) {
            $verts_to_add{$name} = 1 unless $verts_in_db{$name};
        }

        if (keys %verts_to_add) {
            my @vert_sql_values;
            foreach my $vert (keys %verts_to_add) {
                push @vert_sql_values, "('$vert',UNIX_TIMESTAMP())";
            }
            my $vert_sql = join(',', @vert_sql_values);
            do_sql("INSERT INTO vertical (name, createtime) VALUES $vert_sql");
        }
    }

    unless (column_type("vertical_editorials", "img_width")) {
        do_alter("vertical_editorials",
                 "ALTER TABLE vertical_editorials " .
                 "ADD img_width INT(5) UNSIGNED DEFAULT NULL AFTER img_url, " .
                 "ADD img_height INT(5) UNSIGNED DEFAULT NULL AFTER img_width");
    }

    unless (column_type("vertical_editorials", "img_link_url")) {
        do_alter("vertical_editorials",
                 "ALTER TABLE vertical_editorials " .
                 "ADD img_link_url VARCHAR(255) DEFAULT NULL AFTER img_height");
    }

    # add a status column to polls
    unless (column_type("poll", "status")) {
        do_alter("poll",
                 "ALTER TABLE poll ADD status CHAR(1) AFTER name, " .
                 "ADD INDEX (status)");
    }
    unless (column_type("poll2", "status")) {
        do_alter("poll2",
                 "ALTER TABLE poll2 ADD status CHAR(1) AFTER name, " .
                 "ADD INDEX (status)");
    }

    unless (column_type("qotd", "domain")) {
        do_alter("qotd",
                 "ALTER TABLE qotd " .
                 "ADD domain VARCHAR(255) NOT NULL DEFAULT 'homepage'");
    }

    unless (column_type("qotd", "impression_url")) {
        do_alter("qotd",
                 "ALTER TABLE qotd " .
                 "ADD impression_url VARCHAR(255) DEFAULT NULL");
    }

    unless (column_type("qotd", "is_special")) {
        do_alter("qotd",
                 "ALTER TABLE qotd " .
                 "ADD is_special ENUM('Y','N') NOT NULL DEFAULT 'N'");
    }

    unless (column_type("jobstatus", "userid")) {
        do_alter("jobstatus",
                 "ALTER TABLE jobstatus " .
                 "ADD userid INT UNSIGNED DEFAULT NULL"); # yes, we allow userid to be NULL - it means no userid checking
    }

    unless (column_type("supportlog", "tier")) {
        do_alter("supportlog",
                 "ALTER TABLE supportlog " .
                 "ADD tier TINYINT UNSIGNED DEFAULT NULL");
    }
    
    if (column_type("talk2", "jtalkid") =~ /mediumint/) {
        do_alter("talk2",
                 "ALTER TABLE talk2 " .
                 "MODIFY jtalkid INT UNSIGNED NOT NULL");
    }
    
    if (column_type("talk2", "parenttalkid") =~ /mediumint/) {
        do_alter("talk2",
                 "ALTER TABLE talk2 " .
                 "MODIFY parenttalkid INT UNSIGNED NOT NULL");
    }
    
    if (column_type("talkprop2", "jtalkid") =~ /mediumint/) {
        do_alter("talkprop2",
                 "ALTER TABLE talkprop2 " .
                 "MODIFY jtalkid INT UNSIGNED NOT NULL");
    }
    
    if (column_type("talktext2", "jtalkid") =~ /mediumint/) {
        do_alter("talktext2",
                 "ALTER TABLE talktext2 " .
                 "MODIFY jtalkid INT UNSIGNED NOT NULL");
    }

    if (column_type("talkleft", "jtalkid") =~ /mediumint/) {
        do_alter("talkleft",
                 "ALTER TABLE talkleft " .
                 "MODIFY jtalkid INT UNSIGNED NOT NULL");
    }

    if (column_type("talkleft_xfp", "jtalkid") =~ /mediumint/) {
        do_alter("talkleft_xfp",
                 "ALTER TABLE talkleft_xfp " .
                 "MODIFY jtalkid INT UNSIGNED NOT NULL");
    }

    if (column_type("commenturls", "jtalkid") =~ /mediumint/) {
        do_alter("commenturls",
                 "ALTER TABLE commenturls " .
                 "MODIFY jtalkid INT UNSIGNED NOT NULL");
    }

    # no row should have the same url_path and parentcatid
    unless (index_name("category", "UNIQUE:url_path-parentcatid")) {
        do_alter("category", "ALTER IGNORE TABLE category ".
                 "DROP KEY `url_path`, ".
                 "ADD UNIQUE `url_path` (url_path, parentcatid)");
    }

    # add an index on 'country' column
    unless (index_name("schools_pending", "INDEX:country")) {
        do_alter("schools_pending",
                 "ALTER TABLE schools_pending ADD INDEX(country)");
    }

    unless (column_type("comet_history", "status")) {
        do_alter("comet_history",
                 "ALTER TABLE comet_history " .
                 "ADD status char(1) default 'N' after message");
    }

    unless (column_type("ml_latest", "revid")) {
        do_alter("ml_latest",
                 "ALTER TABLE ml_latest " .
                 "ADD revid int unsigned default null");
    }

    unless (column_type("antispam", "date")) {
        do_alter("antispam",
                 "ALTER TABLE antispam " .
                 "MODIFY eventtime DATE DEFAULT NULL");
        do_alter("antispam",
                 "ALTER TABLE antispam ADD INDEX(eventtime)");
    }

});



1; # return true
