unit uZooKeeper;

interface

uses Windows, WinSock2;

const
  LIBFILE = 'zookeeper.dll';

type
  PInt32 = ^Int32;
  pthread_mutex_t = Pointer;
  pthread_cond_t = Pointer;
  pthread_t = Pointer;
  socklen_t = Integer;
  SOCKET = TSocket;
  pzhandle_t=Pointer;
  pzk_hashtable = Pointer;
  psync_completion=Pointer;
  timeval = record
    tv_sec: UInt32; (* seconds *)
    tv_usec: UInt32; (* and microseconds *)
  end;

  ptimeval = ^timeval;


{$REGION 'recordio.h'}

type
  buffer = record
    len: Int32;
    buff: PAnsiChar;
  end;

  pbuffer = ^buffer;

//procedure deallocate_String(var s: PAnsiChar); cdecl;
//procedure deallocate_Buffer(b: pbuffer); cdecl;
//procedure deallocate_vector(d: Pointer); cdecl;

type
  piarchive = ^iarchive;

  iarchive = record
    start_record: function(ia: piarchive; tag: PAnsiChar): Integer; cdecl;
    end_record: function(ia: piarchive; tag: PAnsiChar): Integer; cdecl;
    start_vector: function(ia: piarchive; tag: PAnsiChar; var count: Int32): Integer; cdecl;
    end_vector: function(ia: piarchive; tag: PAnsiChar): Integer; cdecl;
    deserialize_Bool: function(ia: piarchive; name: PAnsiChar; var n: Int32): Integer; cdecl;
    deserialize_Int: function(ia: piarchive; name: PAnsiChar; var n: Int32): Integer; cdecl;
    deserialize_Long: function(ia: piarchive; name: PAnsiChar; var n: Int64): Integer; cdecl;
    deserialize_Buffer: function(ia: piarchive; name: PAnsiChar; buf: pbuffer): Integer; cdecl;
    deserialize_String: function(ia: piarchive; name: PAnsiChar; var s: PAnsiChar): Integer; cdecl;
    priv: Pointer;
  end;

  poarchive = ^oarchive;

  oarchive = record
    start_record: function(oa: poarchive; tag: PAnsiChar): Integer; cdecl;
    end_record: function(oa: poarchive; tag: PAnsiChar): Integer; cdecl;
    start_vector: function(oa: poarchive; tag: PAnsiChar; var count: Int32): Integer; cdecl;
    end_vector: function(oa: poarchive; tag: PAnsiChar): Integer; cdecl;
    serialize_Bool: function(oa: poarchive; name: PAnsiChar; var n: Int32): Integer; cdecl;
    serialize_Int: function(oa: poarchive; name: PAnsiChar; var n: Int32): Integer; cdecl;
    serialize_Long: function(oa: poarchive; name: PAnsiChar; const n: PInt64): Integer; cdecl;
    serialize_Buffer: function(oa: poarchive; name: PAnsiChar; const buf: pbuffer): Integer; cdecl;
    serialize_String: function(oa: poarchive; name: PAnsiChar; var s: PAnsiChar): Integer; cdecl;
    priv: Pointer;
  end;

//function create_buffer_oarchive: poarchive; cdecl;
//procedure close_buffer_oarchive(var oa: poarchive; free_buffer: Integer); cdecl;
//function create_buffer_iarchive(buf: PAnsiChar; len: Integer): piarchive; cdecl;
//procedure close_buffer_iarchive(var ia: piarchive); cdecl;
//
//function get_buffer(p: poarchive): PAnsiChar; cdecl;
//
//function get_buffer_len(p: poarchive): Integer; cdecl;
//
//function zoo_htonll(v: Int64): Int64; cdecl;

{$ENDREGION}

{$REGION 'zookeeper.jute.h'}

type
  Id = record
    scheme: PAnsiChar;
    Id: PAnsiChar;
  end;

  pId = ^Id;
  // function serialize_Id(&out: poarchive;  tag: PAnsiChar;  v: pId): integer; cdecl;
  // function deserialize_Id(&in: piarchive;  tag: PAnsiChar;  v: pId): integer; cdecl;
  // procedure deallocate_Id(i:pID); cdecl;

type
  acl = record
    perms: Int32;
    Id: Id;
  end;

  pACL = ^acl;
  // function serialize_ACL(&out: poarchive;  tag: PAnsiChar;  v: pACL): integer; cdecl;
  // function deserialize_ACL(&in: piarchive;  tag: PAnsiChar;  v: pACL): integer; cdecl;
  // procedure deallocate_ACL(a:pACL);cdecl;

type
  TStat = record
    czxid: Int64;
    mzxid: Int64;
    ctime: Int64;
    mtime: Int64;
    version: Int32;
    cversion: Int32;
    aversion: Int32;
    ephemeralOwner: Int64;
    dataLength: Int32;
    numChildren: Int32;
    pzxid: Int64;
  end;

  pStat = ^TStat;
  // function serialize_Stat(&out: poarchive;  tag: PAnsiChar;  v: pStat): integer; cdecl;
  // function deserialize_Stat(&in: piarchive;  tag: PAnsiChar;  v: pStat): integer; cdecl;
  // procedure deallocate_Stat(s:pStat); cdecl;

type
  StatPersisted = record
    czxid: Int64;
    mzxid: Int64;
    ctime: Int64;
    mtime: Int64;
    version: Int32;
    cversion: Int32;
    aversion: Int32;
    ephemeralOwner: Int64;
    pzxid: Int64;
  end;

  pStatPersisted = ^StatPersisted;
  // function serialize_StatPersisted(&out: poarchive;  tag: PAnsiChar;  v: pStatPersisted): integer;cdecl;
  // function deserialize_StatPersisted(&in: piarchive;  tag: PAnsiChar;  v: pStatPersisted): integer; cdecl;
  // procedure deallocate_StatPersisted(p:pStatPersisted); cdecl;

type
  StatPersistedV1 = record
    czxid: Int64;
    mzxid: Int64;
    ctime: Int64;
    mtime: Int64;
    version: Int32;
    cversion: Int32;
    aversion: Int32;
    ephemeralOwner: Int64;
  end;

  pStatPersistedV1 = ^StatPersistedV1;
  // function serialize_StatPersistedV1(&out: poarchive;  tag: PAnsiChar;  v: pStatPersistedV1): integer; cdecl;
  // function deserialize_StatPersistedV1(&in: piarchive;  tag: PAnsiChar;  v: pStatPersistedV1): integer; cdecl;
  // procedure deallocate_StatPersistedV1(p:pStatPersistedV1); cdecl;

type
  ConnectRequest = record
    protocolVersion: Int32;
    lastZxidSeen: Int64;
    timeOut: Int32;
    sessionId: Int64;
    passwd: buffer;
  end;

  pConnectRequest = ^ConnectRequest;
  // function serialize_ConnectRequest(&out: poarchive;  tag: PAnsiChar;  v: pConnectRequest): integer; cdecl;
  // function deserialize_ConnectRequest(&in: piarchive;  tag: PAnsiChar;  v: pConnectRequest): integer; cdecl;
  // procedure deallocate_ConnectRequest(p:pConnectRequest); cdecl;

type
  ConnectResponse = record
    protocolVersion: Int32;
    timeOut: Int32;
    sessionId: Int64;
    passwd: buffer;
  end;

  pConnectResponse = ^ConnectResponse;
  // function serialize_ConnectResponse(&out: poarchive;  tag: PAnsiChar;  v: pConnectResponse): integer; cdecl;
  // function deserialize_ConnectResponse(&in: piarchive;  tag: PAnsiChar;  v: pConnectResponse): integer; cdecl;
  // procedure deallocate_ConnectResponse(p:pConnectResponse); cdecl;

type
  String_vector = record
    count: Int32;
    data: PPAnsiChar;
  end;

  pString_vector = ^String_vector;
  // function serialize_String_vector(&out: poarchive;  tag: PAnsiChar;  v: pString_vector): integer; cdecl;
  // function deserialize_String_vector(&in: piarchive;  tag: PAnsiChar;  v: pString_vector): integer; cdecl;
  // function allocate_String_vector(v: pString_vector;  len: Int32): integer; cdecl;
  // function deallocate_String_vector(v: pString_vector): integer; cdecl;

type
  SetWatches = record
    relativeZxid: Int64;
    dataWatches: String_vector;
    existWatches: String_vector;
    childWatches: String_vector;
  end;

  pSetWatches = ^SetWatches;
  // function serialize_SetWatches(&out: poarchive;  tag: PAnsiChar;  v: pSetWatches): integer; cdecl;
  // function deserialize_SetWatches(&in: piarchive;  tag: PAnsiChar;  v: pSetWatches): integer; cdecl;
  // procedure deallocate_SetWatches(p:pSetWatches); cdecl;

type
  RequestHeader = record
    xid: Int32;
    &type: Int32;
  end;

  pRequestHeader = ^RequestHeader;
  // function serialize_RequestHeader(&out: poarchive;  tag: PAnsiChar;  v: pRequestHeader): integer; cdecl;
  // function deserialize_RequestHeader(&in: piarchive;  tag: PAnsiChar;  v: pRequestHeader): integer; cdecl;
  // procedure deallocate_RequestHeader(p:pRequestHeader); cdecl;

type
  MultiHeader = record
    &type: Int32;
    done: Int32;
    err: Int32;
  end;

  pMultiHeader = ^MultiHeader;
  // function serialize_MultiHeader(&out: poarchive;  tag: PAnsiChar;  v: pMultiHeader): integer; cdecl;
  // function deserialize_MultiHeader(&in: piarchive;  tag: PAnsiChar;  v: pMultiHeader): integer; cdecl;
  // procedure deallocate_MultiHeader(p:pMultiHeader); cdecl;

type
  AuthPacket = record
    &type: Int32;
    scheme: PAnsiChar;
    auth: buffer;
  end;

  pAuthPacket = ^AuthPacket;
  // function serialize_AuthPacket(&out: poarchive;  tag: PAnsiChar;  v: pAuthPacket): Integer; cdecl;
  // function deserialize_AuthPacket(&in: piarchive;  tag: PAnsiChar;  v: pAuthPacket): Integer; cdecl;
  // procedure deallocate_AuthPacket(p:pAuthPacket); cdecl;

type
  ReplyHeader = record
    xid: Int32;
    zxid: Int64;
    err: Int32;
  end;

  pReplyHeader = ^ReplyHeader;
  // function serialize_ReplyHeader(&out: poarchive;  tag: PAnsiChar;  v: pReplyHeader): Integer; cdecl;
  // function deserialize_ReplyHeader(&in: piarchive;  tag: PAnsiChar;  v: pReplyHeader): Integer; cdecl;
  // procedure deallocate_ReplyHeader(p:pReplyHeader); cdecl;

type
  GetDataRequest = record
    path: PAnsiChar;
    watch: Int32;
  end;

  pGetDataRequest = ^GetDataRequest;
  // function serialize_GetDataRequest(&out: poarchive;  tag: PAnsiChar;  v: pGetDataRequest): Integer; cdecl;
  // function deserialize_GetDataRequest(&in: piarchive;  tag: PAnsiChar;  v: pGetDataRequest): Integer; cdecl;
  // procedure deallocate_GetDataRequest(p:pGetDataRequest); cdecl;

type
  SetDataRequest = record
    path: PAnsiChar;
    data: buffer;
    version: Int32;
  end;

  pSetDataRequest = ^SetDataRequest;
  // function serialize_SetDataRequest(&out: poarchive;  tag: PAnsiChar;  v: pSetDataRequest): Integer; cdecl;
  // function deserialize_SetDataRequest(&in: piarchive;  tag: PAnsiChar;  v: pSetDataRequest): Integer; cdecl;
  // procedure deallocate_SetDataRequest(p:pSetDataRequest); cdecl;

type
  SetDataResponse = record
    TStat: TStat;
  end;

  pSetDataResponse = ^SetDataResponse;
  // function serialize_SetDataResponse(&out: poarchive;  tag: PAnsiChar;  v: pSetDataResponse): Integer; cdecl;
  // function deserialize_SetDataResponse(&in: piarchive;  tag: PAnsiChar;  v: pSetDataResponse): Integer; cdecl;
  // procedure deallocate_SetDataResponse(p:pSetDataResponse); cdecl;

type
  GetSASLRequest = record
    token: buffer;
  end;

  pGetSASLRequest = ^GetSASLRequest;
  // function serialize_GetSASLRequest(&out: poarchive;  tag: PAnsiChar;  v: pGetSASLRequest): Integer; cdecl;
  // function deserialize_GetSASLRequest(&in: piarchive;  tag: PAnsiChar;  v: pGetSASLRequest): Integer; cdecl;
  // procedure deallocate_GetSASLRequest(p:pGetSASLRequest); cdecl;

type
  SetSASLRequest = record
    token: buffer;
  end;

  pSetSASLRequest = ^SetSASLRequest;
  // function serialize_SetSASLRequest(&out: poarchive;  tag: PAnsiChar;  v: pSetSASLRequest): Integer; cdecl;
  // function deserialize_SetSASLRequest(&in: piarchive;  tag: PAnsiChar;  v: pSetSASLRequest): Integer; cdecl;
  // procedure deallocate_SetSASLRequest(p:pSetSASLRequest); cdecl;

type
  SetSASLResponse = record
    token: buffer;
  end;

  pSetSASLResponse = ^SetSASLResponse;
  // function serialize_SetSASLResponse(&out: poarchive;  tag: PAnsiChar;  v: pSetSASLResponse): Integer; cdecl;
  // function deserialize_SetSASLResponse(&in: piarchive;  tag: PAnsiChar;  v: pSetSASLResponse): Integer; cdecl;
  // procedure deallocate_SetSASLResponse(p:pSetSASLResponse); cdecl;

type
  ACL_vector = record
    count: Int32;
    data: pACL;
  end;

  pACL_vector = ^ACL_vector;
  // function serialize_ACL_vector(&out: poarchive;  tag: PAnsiChar;  v: pACL_vector): Integer; cdecl;
  // function deserialize_ACL_vector(&in: piarchive;  tag: PAnsiChar;  v: pACL_vector): Integer; cdecl;
  // function allocate_ACL_vector(v: pACL_vector;  len: Int32): Integer; cdecl;
  // function deallocate_ACL_vector(v: pACL_vector): integer; cdecl;

type
  CreateRequest = record
    path: PAnsiChar;
    data: buffer;
    acl: ACL_vector;
    flags: Int32;
  end;
  // function serialize_CreateRequest(&out: poarchive;  tag: PAnsiChar;  v: pCreateRequest): Integer; cdecl;
  // function deserialize_CreateRequest(&in: piarchive;  tag: PAnsiChar;  v: pCreateRequest): Integer; cdecl;
  // procedure deallocate_CreateRequest(p:pAC); cdecl;

type
  DeleteRequest = record
    path: PAnsiChar;
    version: Int32;
  end;

  pDeleteRequest = ^DeleteRequest;
  // function serialize_DeleteRequest(&out: poarchive;  tag: PAnsiChar;  v: pDeleteRequest): Integer; cdecl;
  // function deserialize_DeleteRequest(&in: piarchive;  tag: PAnsiChar;  v: pDeleteRequest): Integer; cdecl;
  // procedure deallocate_DeleteRequest(p:pDeleteRequest); cdecl;

type
  GetChildrenRequest = record
    path: PAnsiChar;
    watch: Int32;
  end;

  pGetChildrenRequest = ^GetChildrenRequest;
  // function serialize_GetChildrenRequest(&out: poarchive;  tag: PAnsiChar;  v: pGetChildrenRequest): Integer; cdecl;
  // function deserialize_GetChildrenRequest(&in: piarchive;  tag: PAnsiChar;  v: pGetChildrenRequest): Integer; cdecl;
  // procedure deallocate_GetChildrenRequest(p:pGetChildrenRequest); cdecl;

type
  GetChildren2Request = record
    path: PAnsiChar;
    watch: Int32;
  end;

  pGetChildren2Request = ^GetChildren2Request;
  // function serialize_GetChildren2Request(&out: poarchive;  tag: PAnsiChar;  v: pGetChildren2Request): Integer; cdecl;
  // function deserialize_GetChildren2Request(&in: piarchive;  tag: PAnsiChar;  v: pGetChildren2Request): Integer; cdecl;
  // procedure deallocate_GetChildren2Request(p:pGetChildren2Request); cdecl;

type
  CheckVersionRequest = record
    path: PAnsiChar;
    version: Int32;
  end;

  pCheckVersionRequest = ^CheckVersionRequest;
  // function serialize_CheckVersionRequest(&out: poarchive;  tag: PAnsiChar;  v: pCheckVersionRequest): Integer; cdecl;
  // function deserialize_CheckVersionRequest(&in: piarchive;  tag: PAnsiChar;  v: pCheckVersionRequest): Integer; cdecl;
  // procedure deallocate_CheckVersionRequest(p:pCheckVersionRequest); cdecl;

type
  GetMaxChildrenRequest = record
    path: PAnsiChar;
  end;

  pGetMaxChildrenRequest = ^GetMaxChildrenRequest;
  // function serialize_GetMaxChildrenRequest(&out: poarchive;  tag: PAnsiChar;  v: pGetMaxChildrenRequest): Integer; cdecl;
  // function deserialize_GetMaxChildrenRequest(&in: piarchive;  tag: PAnsiChar;  v: pGetMaxChildrenRequest): Integer; cdecl;
  // procedure deallocate_GetMaxChildrenRequest(p:pGetMaxChildrenRequest); cdecl;

type
  GetMaxChildrenResponse = record
    max: Int32;
  end;

  pGetMaxChildrenResponse = ^GetMaxChildrenResponse;
  // function serialize_GetMaxChildrenResponse(&out: poarchive;  tag: PAnsiChar;  v: pGetMaxChildrenResponse): Integer; cdecl;
  // function deserialize_GetMaxChildrenResponse(&in: piarchive;  tag: PAnsiChar;  v: pGetMaxChildrenResponse): Integer; cdecl;
  // procedure deallocate_GetMaxChildrenResponse(p:pGetMaxChildrenResponse); cdecl;

type
  SetMaxChildrenRequest = record
    path: PAnsiChar;
    max: Int32;
  end;

  pSetMaxChildrenRequest = ^SetMaxChildrenRequest;
  // function serialize_SetMaxChildrenRequest(&out: poarchive;  tag: PAnsiChar;  v: pSetMaxChildrenRequest): Integer; cdecl;
  // function deserialize_SetMaxChildrenRequest(&in: piarchive;  tag: PAnsiChar;  v: pSetMaxChildrenRequest): Integer; cdecl;
  // procedure deallocate_SetMaxChildrenRequest(p:pSetMaxChildrenRequest); cdecl;

type
  SyncRequest = record
    path: PAnsiChar;
  end;

  pSyncRequest = ^SyncRequest;
  // function serialize_SyncRequest(&out: poarchive;  tag: PAnsiChar;  v: pSyncRequest): Integer; cdecl;
  // function deserialize_SyncRequest(&in: piarchive;  tag: PAnsiChar;  v: pSyncRequest): Integer; cdecl;
  // procedure deallocate_SyncRequest(p:pSyncRequest); cdecl;

type
  SyncResponse = record
    path: PAnsiChar;
  end;

  pSyncResponse = ^SyncResponse;
  // function serialize_SyncResponse(&out: poarchive;  tag: PAnsiChar;  v: pSyncResponse): Integer; cdecl;
  // function deserialize_SyncResponse(&in: piarchive;  tag: PAnsiChar;  v: pSyncResponse): Integer; cdecl;
  // procedure deallocate_SyncResponse(p:pSyncResponse); cdecl;

type
  GetACLRequest = record
    path: PAnsiChar;
  end;

  pGetACLRequest = ^GetACLRequest;
  // function serialize_GetACLRequest(&out: poarchive;  tag: PAnsiChar;  v: pGetACLRequest): Integer; cdecl;
  // function deserialize_GetACLRequest(&in: piarchive;  tag: PAnsiChar;  v: pGetACLRequest): Integer; cdecl;
  // procedure deallocate_GetACLRequest(p:pGetACLRequest); cdecl;

type
  SetACLRequest = record
    path: PAnsiChar;
    acl: ACL_vector;
    version: Int32;
  end;

  pSetACLRequest = ^SetACLRequest;
  // function serialize_SetACLRequest(&out: poarchive;  tag: PAnsiChar;  v: pSetACLRequest): Integer; cdecl;
  // function deserialize_SetACLRequest(&in: piarchive;  tag: PAnsiChar;  v: pSetACLRequest): Integer; cdecl;
  // procedure deallocate_SetACLRequest(p:pSetACLRequest); cdecl;

type
  SetACLResponse = record
    TStat: TStat;
  end;

  pSetACLResponse = ^SetACLResponse;
  // function serialize_SetACLResponse(&out: poarchive;  tag: PAnsiChar;  v: pSetACLResponse): Integer; cdecl;
  // function deserialize_SetACLResponse(&in: piarchive;  tag: PAnsiChar;  v: pSetACLResponse): Integer; cdecl;
  // procedure deallocate_SetACLResponse(p:pSetACLResponse); cdecl;

type
  WatcherEvent = record
    &type: Int32;
    state: Int32;
    path: PAnsiChar;
  end;

  pWatcherEvent = ^WatcherEvent;
  // function serialize_WatcherEvent(&out: poarchive;  tag: PAnsiChar;  v: pWatcherEvent): Integer; cdecl;
  // function deserialize_WatcherEvent(&in: piarchive;  tag: PAnsiChar;  v: pWatcherEvent): Integer; cdecl;
  // procedure deallocate_WatcherEvent(p:pWatcherEvent); cdecl;

type
  ErrorResponse = record
    err: Int32;
  end;

  pErrorResponse = ^ErrorResponse;
  // function serialize_ErrorResponse(&out: poarchive;  tag: PAnsiChar;  v: pErrorResponse): Integer; cdecl;
  // function deserialize_ErrorResponse(&in: piarchive;  tag: PAnsiChar;  v: pErrorResponse): Integer; cdecl;
  // procedure deallocate_ErrorResponse(p:pErrorResponse); cdecl;

type
  CreateResponse = record
    path: PAnsiChar;
  end;

  pCreateResponse = ^CreateResponse;
  // function serialize_CreateResponse(&out: poarchive;  tag: PAnsiChar;  v: pCreateResponse): Integer; cdecl;
  // function deserialize_CreateResponse(&in: piarchive;  tag: PAnsiChar;  v: pCreateResponse): Integer; cdecl;
  // procedure deallocate_CreateResponse(p:pCreateResponse); cdecl;

type
  ExistsRequest = record
    path: PAnsiChar;
    watch: Int32;
  end;

  pExistsRequest = ^ExistsRequest;
  // function serialize_ExistsRequest(&out: poarchive;  tag: PAnsiChar;  v: pExistsRequest): Integer; cdecl;
  // function deserialize_ExistsRequest(&in: piarchive;  tag: PAnsiChar;  v: pExistsRequest): Integer; cdecl;
  // procedure deallocate_ExistsRequest(p:pExistsRequest); cdecl;

type
  ExistsResponse = record
    TStat: TStat;
  end;

  pExistsResponse = ^ExistsResponse;
  // function serialize_ExistsResponse(&out: poarchive;  tag: PAnsiChar;  v: pExistsResponse): Integer; cdecl;
  // function deserialize_ExistsResponse(&in: piarchive;  tag: PAnsiChar;  v: pExistsResponse): Integer; cdecl;
  // procedure deallocate_ExistsResponse(p:pExistsResponse); cdecl;

type
  GetDataResponse = record
    data: buffer;
    TStat: TStat;
  end;

  pGetDataResponse = ^GetDataResponse;
  // function serialize_GetDataResponse(&out: poarchive;  tag: PAnsiChar;  v: pGetDataResponse): Integer; cdecl;
  // function deserialize_GetDataResponse(&in: piarchive;  tag: PAnsiChar;  v: pGetDataResponse): Integer; cdecl;
  // procedure deallocate_GetDataResponse(p:pGetDataResponse); cdecl;

type
  GetChildrenResponse = record
    children: String_vector;
  end;

  pGetChildrenResponse = ^GetChildrenResponse;
  // function serialize_GetChildrenResponse(&out: poarchive;  tag: PAnsiChar;  v: pGetChildrenResponse): Integer; cdecl;
  // function deserialize_GetChildrenResponse(&in: piarchive;  tag: PAnsiChar;  v: pGetChildrenResponse): Integer; cdecl;
  // procedure deallocate_GetChildrenResponse(p:pGetChildrenResponse); cdecl;

type
  GetChildren2Response = record
    children: String_vector;
    TStat: TStat;
  end;

  pGetChildren2Response = ^GetChildren2Response;
  // function serialize_GetChildren2Response(&out: poarchive;  tag: PAnsiChar;  v: pGetChildren2Response): Integer; cdecl;
  // function deserialize_GetChildren2Response(&in: piarchive;  tag: PAnsiChar;  v: pGetChildren2Response): Integer; cdecl;
  // procedure deallocate_GetChildren2Response(p:pGetChildren2Response); cdecl;

type
  GetACLResponse = record
    acl: ACL_vector;
    TStat: TStat;
  end;

  pGetACLResponse = ^GetACLResponse;
  // function serialize_GetACLResponse(&out: poarchive;  tag: PAnsiChar;  v: pGetACLResponse): Integer; cdecl;
  // function deserialize_GetACLResponse(&in: piarchive;  tag: PAnsiChar;  v: pGetACLResponse): Integer; cdecl;
  // procedure deallocate_GetACLResponse(p:pGetACLResponse); cdecl;

type
  LearnerInfo = record
    serverid: Int64;
    protocolVersion: Int32;
  end;

  pLearnerInfo = ^LearnerInfo;
  // function serialize_LearnerInfo(&out: poarchive;  tag: PAnsiChar;  v: pLearnerInfo): Integer; cdecl;
  // function deserialize_LearnerInfo(&in: piarchive;  tag: PAnsiChar;  v: pLearnerInfo): Integer; cdecl;
  // procedure deallocate_LearnerInfo(p:pLearnerInfo); cdecl;

type
  Id_vector = record
    count: Int32;
    data: pId;
  end;

  pId_vector = ^Id_vector;
  // function serialize_Id_vector(&out: poarchive;  tag: PAnsiChar;  v: pId_vector): Integer; cdecl;
  // function deserialize_Id_vector(&in: piarchive;  tag: PAnsiChar;  v: pId_vector): Integer; cdecl;
  // function allocate_Id_vector(v: pId_vector;  len: Int32): Integer; cdecl;
  // function deallocate_Id_vector(v: pId_vector): integer; cdecl;

type
  QuorumPacket = record
    &type: Int32;
    zxid: Int64;
    data: buffer;
    authinfo: Id_vector;
  end;
  // function serialize_QuorumPacket(&out: poarchive;  tag: PAnsiChar;  v: pQuorumPacket): Integer; cdecl;
  // function deserialize_QuorumPacket(&in: piarchive;  tag: PAnsiChar;  v: pQuorumPacket): Integer; cdecl;
  // procedure deallocate_QuorumPacket(p:pI); cdecl;

type
  FileHeader = record
    magic: Int32;
    version: Int32;
    dbid: Int64;
  end;

  pFileHeader = ^FileHeader;
  // function serialize_FileHeader(&out: poarchive;  tag: PAnsiChar;  v: pFileHeader): Integer; cdecl;
  // function deserialize_FileHeader(&in: piarchive;  tag: PAnsiChar;  v: pFileHeader): Integer; cdecl;
  // procedure deallocate_FileHeader(p:pFileHeader); cdecl;

type
  TxnHeader = record
    clientId: Int64;
    cxid: Int32;
    zxid: Int64;
    time: Int64;
    &type: Int32;
  end;

  pTxnHeader = ^TxnHeader;
  // function serialize_TxnHeader(&out: poarchive;  tag: PAnsiChar;  v: pTxnHeader): Integer; cdecl;
  // function deserialize_TxnHeader(&in: piarchive;  tag: PAnsiChar;  v: pTxnHeader): Integer; cdecl;
  // procedure deallocate_TxnHeader(p:pTxnHeader); cdecl;

type
  CreateTxnV0 = record
    path: PAnsiChar;
    data: buffer;
    acl: ACL_vector;
    ephemeral: Int32;
  end;

  pCreateTxnV0 = ^CreateTxnV0;
  // function serialize_CreateTxnV0(&out: poarchive;  tag: PAnsiChar;  v: pCreateTxnV0): Integer; cdecl;
  // function deserialize_CreateTxnV0(&in: piarchive;  tag: PAnsiChar;  v: pCreateTxnV0): Integer; cdecl;
  // procedure deallocate_CreateTxnV0(p:pCreateTxnV0); cdecl;

type
  CreateTxn = record
    path: PAnsiChar;
    data: buffer;
    acl: ACL_vector;
    ephemeral: Int32;
    parentCVersion: Int32;
  end;

  pCreateTxn = ^CreateTxn;
  // function serialize_CreateTxn(&out: poarchive;  tag: PAnsiChar;  v: pCreateTxn): Integer; cdecl;
  // function deserialize_CreateTxn(&in: piarchive;  tag: PAnsiChar;  v: pCreateTxn): Integer; cdecl;
  // procedure deallocate_CreateTxn(p:pCreateTxn); cdecl;

type
  DeleteTxn = record
    path: PAnsiChar;
  end;

  pDeleteTxn = ^DeleteTxn;
  // function serialize_DeleteTxn(&out: poarchive;  tag: PAnsiChar;  v: pDeleteTxn): Integer; cdecl;
  // function deserialize_DeleteTxn(&in: piarchive;  tag: PAnsiChar;  v: pDeleteTxn): Integer; cdecl;
  // procedure deallocate_DeleteTxn(p:pDeleteTxn); cdecl;

type
  SetDataTxn = record
    path: PAnsiChar;
    data: buffer;
    version: Int32;
  end;

  pSetDataTxn = ^SetDataTxn;
  // function serialize_SetDataTxn(&out: poarchive;  tag: PAnsiChar;  v: pSetDataTxn): Integer; cdecl;
  // function deserialize_SetDataTxn(&in: piarchive;  tag: PAnsiChar;  v: pSetDataTxn): Integer; cdecl;
  // procedure deallocate_SetDataTxn(p:pSetDataTxn); cdecl;

type
  CheckVersionTxn = record
    path: PAnsiChar;
    version: Int32;
  end;

  pCheckVersionTxn = ^CheckVersionTxn;
  // function serialize_CheckVersionTxn(&out: poarchive;  tag: PAnsiChar;  v: pCheckVersionTxn): Integer; cdecl;
  // function deserialize_CheckVersionTxn(&in: piarchive;  tag: PAnsiChar;  v: pCheckVersionTxn): Integer; cdecl;
  // procedure deallocate_CheckVersionTxn(p:pCheckVersionTxn); cdecl;

type
  SetACLTxn = record
    path: PAnsiChar;
    acl: ACL_vector;
    version: Int32;
  end;

  pSetACLTxn = ^SetACLTxn;
  // function serialize_SetACLTxn(&out: poarchive;  tag: PAnsiChar;  v: pSetACLTxn): Integer; cdecl;
  // function deserialize_SetACLTxn(&in: piarchive;  tag: PAnsiChar;  v: pSetACLTxn): Integer; cdecl;
  // procedure deallocate_SetACLTxn(p:pSetACLTxn); cdecl;

type
  SetMaxChildrenTxn = record
    path: PAnsiChar;
    max: Int32;
  end;

  pSetMaxChildrenTxn = ^SetMaxChildrenTxn;
  // function serialize_SetMaxChildrenTxn(&out: poarchive;  tag: PAnsiChar;  v: pSetMaxChildrenTxn): Integer; cdecl;
  // function deserialize_SetMaxChildrenTxn(&in: piarchive;  tag: PAnsiChar;  v: pSetMaxChildrenTxn): Integer; cdecl;
  // procedure deallocate_SetMaxChildrenTxn(p:pSetMaxChildrenTxn); cdecl;

type
  CreateSessionTxn = record
    timeOut: Int32;
  end;

  pCreateSessionTxn = ^CreateSessionTxn;
  // function serialize_CreateSessionTxn(&out: poarchive;  tag: PAnsiChar;  v: pCreateSessionTxn): Integer; cdecl;
  // function deserialize_CreateSessionTxn(&in: piarchive;  tag: PAnsiChar;  v: pCreateSessionTxn): Integer; cdecl;
  // procedure deallocate_CreateSessionTxn(p:pCreateSessionTxn); cdecl;

type
  ErrorTxn = record
    err: Int32;
  end;

  pErrorTxn = ^ErrorTxn;
  // function serialize_ErrorTxn(&out: poarchive;  tag: PAnsiChar;  v: pErrorTxn): Integer; cdecl;
  // function deserialize_ErrorTxn(&in: piarchive;  tag: PAnsiChar;  v: pErrorTxn): Integer; cdecl;
  // procedure deallocate_ErrorTxn(p:pErrorTxn); cdecl;

type
  Txn = record
    &type: Int32;
    data: buffer;
  end;

  pTxn = ^Txn;
  // function serialize_Txn(&out: poarchive;  tag: PAnsiChar;  v: pTxn): Integer; cdecl;
  // function deserialize_Txn(&in: piarchive;  tag: PAnsiChar;  v: pTxn): Integer; cdecl;
  // procedure deallocate_Txn(p:pTxn); cdecl;

type
  Txn_vector = record
    count: Int32;
    data: pTxn;
  end;

  pTxn_vector = ^Txn_vector;
  // function serialize_Txn_vector(&out: poarchive;  tag: PAnsiChar;  v: pTxn_vector): Integer; cdecl;
  // function deserialize_Txn_vector(&in: piarchive;  tag: PAnsiChar;  v: pTxn_vector): Integer; cdecl;
  // function allocate_Txn_vector(v: pTxn_vector;  len: Int32): Integer; cdecl;
  // function deallocate_Txn_vector(v: pTxn_vector): integer; cdecl;

type
  MultiTxn = record
    txns: Txn_vector;
  end;

  pMultiTxn = ^MultiTxn;

  // function serialize_MultiTxn(&out: poarchive;  tag: PAnsiChar;  v: pMultiTxn): Integer; cdecl;
  // function deserialize_MultiTxn(&in: piarchive;  tag: PAnsiChar;  v: pMultiTxn): Integer; cdecl;
  // procedure deallocate_MultiTxn(p:pMultiTxn); cdecl;
{$ENDREGION}
{$REGION 'zk_adaptor.h const'}

const
  // predefined xid's values recognized as special by the server
  WATCHER_EVENT_XID = -1;
  PING_XID = -2;
  AUTH_XID = -4;
  SET_WATCHES_XID = -8;

  // zookeeper state constants */
  EXPIRED_SESSION_STATE_DEF = -112;
  AUTH_FAILED_STATE_DEF = -113;
  CONNECTING_STATE_DEF = 1;
  ASSOCIATING_STATE_DEF = 2;
  CONNECTED_STATE_DEF = 3;
  NOTCONNECTED_STATE_DEF = 999;

  // * zookeeper event type constants */
  CREATED_EVENT_DEF = 1;
  DELETED_EVENT_DEF = 2;
  CHANGED_EVENT_DEF = 3;
  CHILD_EVENT_DEF = 4;
  SESSION_EVENT_DEF = -1;
  NOTWATCHING_EVENT_DEF = -2;
{$ENDREGION}



{$REGION 'zookeeper.h'}
  (* *
    * \file zookeeper.h
    * \brief ZooKeeper functions and definitions.
    *
    * ZooKeeper is a network service that may be backed by a cluster of
    * synchronized servers. The data in the service is represented as a tree
    * of data nodes. Each node has data, children, an ACL, and status information.
    * The data for a node is read and write in its entirety.
    *
    * ZooKeeper clients can leave watches when they queries the data or children
    * of a node. If a watch is left, that client will be notified of the change.
    * The notification is a one time trigger. Subsequent chances to the node will
    * not trigger a notification unless the client issues a query with the watch
    * flag set. If the client is ever disconnected from the service, the watches do
    * not need to be reset. The client automatically resets the watches.
    *
    * When a node is created, it may be flagged as an ephemeral node. Ephemeral
    * nodes are automatically removed when a client session is closed or when
    * a session times out due to inactivity (the ZooKeeper runtime fills in
    * periods of inactivity with pings). Ephemeral nodes cannot have children.
    *
    * ZooKeeper clients are identified by a server assigned session id. For
    * security reasons The server
    * also generates a corresponding password for a session. A client may save its
    * id and corresponding password to persistent storage in order to use the
    * session across program invocation boundaries.
  *)

  (* * zookeeper return constants * *)
type
  ZOO_ERRORS = (ZOK = 0, (* !< Everything is OK *)
    ZSYSTEMERROR = -1,

    (* * System and server-side errors.
      * This is never thrown by the server, it shouldn't be used other than
      * to indicate a range. Specifically error codes greater than this
      * value, but lesser than {@link #ZAPIERROR}, are system errors. *)
    ZRUNTIMEINCONSISTENCY = -2, (* !< A runtime inconsistency was found *)
    ZDATAINCONSISTENCY = -3, (* !< A data inconsistency was found *)

    ZCONNECTIONLOSS = -4, (* !< Connection to the server has been lost *)

    ZMARSHALLINGERROR = -5, (* !< Error while marshalling or unmarshalling data *)

    ZUNIMPLEMENTED = -6, (* !< Operation is unimplemented *)

    ZOPERATIONTIMEOUT = -7, (* !< Operation timeout *)

    ZBADARGUMENTS = -8, (* !< Invalid arguments *)

    ZINVALIDSTATE = -9, (* !< Invliad zhandle state *)

    (* * API errors.
      * This is never thrown by the server, it shouldn't be used other than
      * to indicate a range. Specifically error codes greater than this
      * value are API errors (while values less than this indicate a
      * {@link #ZSYSTEMERROR}).
    *)
    ZAPIERROR = -100,

    ZNONODE = -101, (* !< Node does not exist *)
    ZNOAUTH = -102, (* !< Not authenticated *)

    ZBADVERSION = -103, (* !< Version conflict *)

    ZNOCHILDRENFOREPHEMERALS = -108, (* !< Ephemeral nodes may not have children *)

    ZNODEEXISTS = -110, (* !< The node already exists *)

    ZNOTEMPTY = -111, (* !< The node has children *)

    ZSESSIONEXPIRED = -112, (* !< The session has been expired by the server *)

    ZINVALIDCALLBACK = -113, (* !< Invalid callback specified *)
    ZINVALIDACL = -114, (* !< Invalid ACL specified *)
    ZAUTHFAILED = -115, (* !< Client authentication failed *)
    ZCLOSING = -116, (* !< ZooKeeper is closing *)
    ZNOTHING = -117, (* !< (not error) no server responses to process *)
    ZSESSIONMOVED = -118); (* !<session moved to another server, so operation is ignored *)

  (* *
    *  @name Debug levels
  *)
  ZooLogLevel = (ZOO_LOG_LEVEL_ERROR = 1, ZOO_LOG_LEVEL_WARN = 2, ZOO_LOG_LEVEL_INFO = 3, ZOO_LOG_LEVEL_DEBUG = 4);

  (* *
    * @name ACL Consts
  *)
const
  ZOO_PERM_READ = 1 shl 0;
  ZOO_PERM_WRITE = 1 shl 1;
  ZOO_PERM_CREATE = 1 shl 2;
  ZOO_PERM_DELETE = 1 shl 3;
  ZOO_PERM_ADMIN = 1 shl 4;
  ZOO_PERM_ALL = $1F;
  (* * This Id represents anyone. *)
  ZOO_ANYONE_ID_UNSAFE: Id = (scheme: 'world'; Id: 'anyone');
  (* This Id is only usable to set ACLs. It will get substituted with the
    * Id's the client authenticated with.
  *)
  ZOO_AUTH_IDS: Id = (scheme: 'auth'; Id: '');
  _OPEN_ACL_UNSAFE_ACL: acl = (perms: $1F; Id: (scheme: 'world'; Id: 'anyone'));
  _READ_ACL_UNSAFE_ACL: acl = (perms: $01; Id: (scheme: 'world'; Id: 'anyone'));
  _CREATOR_ALL_ACL_ACL: acl = (perms: $1F; Id: (scheme: 'auth'; Id: ''));

  (* This is a completely open ACL *)
  ZOO_OPEN_ACL_UNSAFE: ACL_vector = (count: 1; data: @_OPEN_ACL_UNSAFE_ACL);
  (* This ACL gives the world the ability to read. *)
  ZOO_READ_ACL_UNSAFE: ACL_vector = (count: 1; data: @_READ_ACL_UNSAFE_ACL);
  (* This ACL gives the creators authentication id's all permissions. *)
  ZOO_CREATOR_ALL_ACL: ACL_vector = (count: 1; data: @_CREATOR_ALL_ACL_ACL);

  (*
    * @name Interest Consts
    * These constants are used to express interest in an event and to
    * indicate to zookeeper which events have occurred. They can
    * be ORed together to express multiple interests. These flags are
    * used in the interest and event parameters of
    * \ref zookeeper_interest and \ref zookeeper_process.
  *)
const
  ZOOKEEPER_WRITE = 1 shl 0;
  ZOOKEEPER_READ = 1 shl 1;

  (* *
    * @name Create Flags
    *
    * These flags are used by zoo_create to affect node create. They may
    * be ORed together to combine effects.
  *)
const
  ZOO_EPHEMERAL = 1 shl 0;
  ZOO_SEQUENCE = 1 shl 1;

  (* *
    * @name State Consts
    * These constants represent the states of a zookeeper connection. They are
    * possible parameters of the watcher callback.
  *)
const
  ZOO_EXPIRED_SESSION_STATE = EXPIRED_SESSION_STATE_DEF;
  ZOO_AUTH_FAILED_STATE = AUTH_FAILED_STATE_DEF;
  ZOO_CONNECTING_STATE = CONNECTING_STATE_DEF;
  ZOO_ASSOCIATING_STATE = ASSOCIATING_STATE_DEF;
  ZOO_CONNECTED_STATE = CONNECTED_STATE_DEF;

  (* *
    * @name Watch Types
    * These constants indicate the event that caused the watch event. They are
    * possible values of the first parameter of the watcher callback.
  *)
  (* @{ *)
  (* *
    * \brief a node has been created.
    *
    * This is only generated by watches on non-existent nodes. These watches
    * are set using \ref zoo_exists.
  *)
const
  ZOO_CREATED_EVENT = CREATED_EVENT_DEF;

  (* *
    * \brief a node has been deleted.
    *
    * This is only generated by watches on nodes. These watches
    * are set using \ref zoo_exists and \ref zoo_get.
  *)
  ZOO_DELETED_EVENT = DELETED_EVENT_DEF;

  (* *
    * \brief a node has changed.
    *
    * This is only generated by watches on nodes. These watches
    * are set using \ref zoo_exists and \ref zoo_get.
  *)
  ZOO_CHANGED_EVENT = CHANGED_EVENT_DEF;
  (* *
    * \brief a change as occurred in the list of children.
    *
    * This is only generated by watches on the child list of a node. These watches
    * are set using \ref zoo_get_children or \ref zoo_get_children2.
  *)
  ZOO_CHILD_EVENT = CHILD_EVENT_DEF;
  (* *
    * \brief a session has been lost.
    *
    * This is generated when a client loses contact or reconnects with a server.
  *)
  ZOO_SESSION_EVENT = SESSION_EVENT_DEF;
  (* *
    * \brief a watch has been removed.
    *
    * This is generated when the server for some reason, probably a resource
    * constraint, will no longer watch a node for a client.
  *)
  ZOO_NOTWATCHING_EVENT = NOTWATCHING_EVENT_DEF;

  (* *
    * \brief ZooKeeper handle.
    *
    * This is the handle that represents a connection to the ZooKeeper service.
    * It is needed to invoke any ZooKeeper function. A handle is obtained using
    * \ref zookeeper_init.
  *)
type
//  pzhandle_t = Pointer;

  (* *
    * \brief client id structure.
    *
    * This structure holds the id and password for the session. This structure
    * should be treated as opaque. It is received from the server when a session
    * is established and needs to be sent back as-is when reconnecting a session.
  *)
  clientid_t = record
    client_id: Int64;
    passwd: array [0 .. Pred(16)] of AnsiChar;
  end;

  pclientid_t = ^clientid_t;

  (* *
    * \brief zoo_op structure.
    *
    * This structure holds all the arguments necessary for one op as part
    * of a containing multi_op via \ref zoo_multi or \ref zoo_amulti.
    * This structure should be treated as opaque and initialized via
    * \ref zoo_create_op_init, \ref zoo_delete_op_init, \ref zoo_set_op_init
    * and \ref zoo_check_op_init.
  *)
  zoo_op = record
    case &type: Integer of
      // CREATE
      0:
        (create_op: record path: PAnsiChar;
          data: PAnsiChar;
          datalen: Integer;
          buf: PAnsiChar;
          buflen: Integer;
          acl: pACL_vector;
          flags: Integer;
        end);
      (* DELETE *)
      1:
        (delete_op: record path: PAnsiChar;
          version: Integer;
        end);
      (* SET *)
      2:
        (set_op: record path: PAnsiChar;
          data: PAnsiChar;
          datalen: Integer;
          version: Integer;
          TStat: pStat;
        end);
      (* CHECK *)
      3:
        (check_op: record path: PAnsiChar;
          version: Integer;
        end);
  end;

  zoo_op_t = zoo_op;
  pzoo_op_t = ^zoo_op_t;
  (* *
    * \brief zoo_create_op_init.
    *
    * This function initializes a zoo_op_t with the arguments for a ZOO_CREATE_OP.
    *
    * \param op A pointer to the zoo_op_t to be initialized.
    * \param path The name of the node. Expressed as a file name with slashes
    * separating ancestors of the node.
    * \param value The data to be stored in the node.
    * \param valuelen The number of bytes in data. To set the data to be NULL use
    * value as NULL and valuelen as -1.
    * \param acl The initial ACL of the node. The ACL must not be null or empty.
    * \param flags this parameter can be set to 0 for normal create or an OR
    *    of the Create Flags
    * \param path_buffer Buffer which will be filled with the path of the
    *    new node (this might be different than the supplied path
    *    because of the ZOO_SEQUENCE flag).  The path string will always be
    *    null-terminated. This parameter may be NULL if path_buffer_len = 0.
    * \param path_buffer_len Size of path buffer; if the path of the new
    *    node (including space for the null terminator) exceeds the buffer size,
    *    the path string will be truncated to fit.  The actual path of the
    *    new node in the server will not be affected by the truncation.
    *    The path string will always be null-terminated.
  *)

procedure zoo_create_op_init(op: pzoo_op_t; path: PAnsiChar; value: PAnsiChar; valuelen: Integer; acl: pACL_vector; flags: Integer; path_buffer: PAnsiChar; path_buffer_len: Integer); cdecl;
(* *
  * \brief zoo_delete_op_init.
  *
  * This function initializes a zoo_op_t with the arguments for a ZOO_DELETE_OP.
  *
  * \param op A pointer to the zoo_op_t to be initialized.
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param version the expected version of the node. The function will fail if the
  *    actual version of the node does not match the expected version.
  *  If -1 is used the version check will not take place.
*)

procedure zoo_delete_op_init(op: pzoo_op_t; path: PAnsiChar; version: Integer); cdecl;
(* *
  * \brief zoo_set_op_init.
  *
  * This function initializes an zoo_op_t with the arguments for a ZOO_SETDATA_OP.
  *
  * \param op A pointer to the zoo_op_t to be initialized.
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param buffer the buffer holding data to be written to the node.
  * \param buflen the number of bytes from buffer to write. To set NULL as data
  * use buffer as NULL and buflen as -1.
  * \param version the expected version of the node. The function will fail if
  * the actual version of the node does not match the expected version. If -1 is
  * used the version check will not take place.
*)

procedure zoo_set_op_init(op: pzoo_op_t; path: PAnsiChar; buffer: PAnsiChar; buflen: Integer; version: Integer; TStat: pStat); cdecl;
(* *
  * \brief zoo_check_op_init.
  *
  * This function initializes an zoo_op_t with the arguments for a ZOO_CHECK_OP.
  *
  * \param op A pointer to the zoo_op_t to be initialized.
  * \param path The name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param version the expected version of the node. The function will fail if the
  *    actual version of the node does not match the expected version.
*)

procedure zoo_check_op_init(op: pzoo_op_t; path: PAnsiChar; version: Integer); cdecl;

(* *
  * \brief zoo_op_result structure.
  *
  * This structure holds the result for an op submitted as part of a multi_op
  * via \ref zoo_multi or \ref zoo_amulti.
*)
type
  zoo_op_result = record
    err: Integer;
    value: PAnsiChar;
    valuelen: Integer;
    TStat: pStat;
  end;

  zoo_op_result_t = zoo_op_result;
  pzoo_op_result_t = ^zoo_op_result_t;

  (* *
    * \brief signature of a watch function.
    *
    * There are two ways to receive watch notifications: legacy and watcher object.
    * <p>
    * The legacy style, an application wishing to receive events from ZooKeeper must
    * first implement a function with this signature and pass a pointer to the function
    * to \ref zookeeper_init. Next, the application sets a watch by calling one of
    * the getter API that accept the watch integer flag (for example, \ref zoo_aexists,
    * \ref zoo_get, etc).
    * <p>
    * The watcher object style uses an instance of a 'watcher object' which in
    * the C world is represented by a pair: a pointer to a function implementing this
    * signature and a pointer to watcher context -- handback user-specific data.
    * When a watch is triggered this function will be called along with
    * the watcher context. An application wishing to use this style must use
    * the getter API functions with the 'w' prefix in their names (for example, \ref
    * zoo_awexists, \ref zoo_wget, etc).
    *
    * \param zh zookeeper handle
    * \param type event type. This is one of the *_EVENT constants.
    * \param state connection state. The state value will be one of the *_STATE constants.
    * \param path znode path for which the watcher is triggered. NULL if the event
    * type is ZOO_SESSION_EVENT
    * \param watcherCtx watcher context.
  *)
  watcher_fn = procedure(zh: pzhandle_t; &type: Integer; state: Integer; path: PAnsiChar; watcherCtx: Pointer); cdecl;
  (* *
    * \brief create a handle to used communicate with zookeeper.
    *
    * This method creates a new handle and a zookeeper session that corresponds
    * to that handle. Session establishment is asynchronous, meaning that the
    * session should not be considered established until (and unless) an
    * event of state ZOO_CONNECTED_STATE is received.
    * \param host comma separated host:port pairs, each corresponding to a zk
    *   server. e.g. '127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002'
    * \param fn the global watcher callback function. When notifications are
    *   triggered this function will be invoked.
    * \param clientid the id of a previously established session that this
    *   client will be reconnecting to. Pass 0 if not reconnecting to a previous
    *   session. Clients can access the session id of an established, valid,
    *   connection by calling \ref zoo_client_id. If the session corresponding to
    *   the specified clientid has expired, or if the clientid is invalid for
    *   any reason, the returned zhandle_t will be invalid -- the zhandle_t
    *   state will indicate the reason for failure (typically
    *   ZOO_EXPIRED_SESSION_STATE).
    * \param context the handback object that will be associated with this instance
    *   of zhandle_t. Application can access it (for example, in the watcher
    *   callback) using \ref zoo_get_context. The object is not used by zookeeper
    *   internally and can be null.
    * \param flags reserved for future use. Should be set to zero.
    * \return a pointer to the opaque zhandle structure. If it fails to create
    * a new zhandle the function returns NULL and the errno variable
    * indicates the reason.
  *)

function zookeeper_init(host: PAnsiChar; fn: watcher_fn; recv_timeout: Integer; clientId: pclientid_t; context: Pointer; flags: Integer): pzhandle_t { ZOOAPI }{ <= !!!4 unknown type };
(* *
  * \brief close the zookeeper handle and free up any resources.
  *
  * After this call, the client session will no longer be valid. The function
  * will flush any outstanding send requests before return. As a result it may
  * block.
  *
  * This method should only be called only once on a zookeeper handle. Calling
  * twice will cause undefined (and probably undesirable behavior). Calling any other
  * zookeeper method after calling close is undefined behaviour and should be avoided.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \return a result code. Regardless of the error code returned, the zhandle
  * will be destroyed and all resources freed.
  *
  * ZOK - success
  * ZBADARGUMENTS - invalid input parameters
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
  * ZOPERATIONTIMEOUT - failed to flush the buffers within the specified timeout.
  * ZCONNECTIONLOSS - a network error occured while attempting to send request to server
  * ZSYSTEMERROR -- a system (OS) error occured; it's worth checking errno to get details
*)

function zookeeper_close(zh: pzhandle_t): Integer; cdecl;
(* *
  * \brief return the client session id, only valid if the connections
  * is currently connected (ie. last watcher state is ZOO_CONNECTED_STATE)
*)

function zoo_client_id(zh: pzhandle_t): pclientid_t; cdecl;
(* *
  * \brief return the timeout for this session, only valid if the connections
  * is currently connected (ie. last watcher state is ZOO_CONNECTED_STATE). This
  * value may change after a server re-connect.
*)

function zoo_recv_timeout(zh: pzhandle_t): Integer; cdecl;
(* *
  * \brief return the context for this handle.
*)

function zoo_get_context(zh: pzhandle_t): Pointer; cdecl;
(* *
  * \brief set the context for this handle.
*)

procedure zoo_set_context(zh: pzhandle_t; context: Pointer); cdecl;
(* *
  * \brief set a watcher function
  * \return previous watcher function
*)

function zoo_set_watcher(zh: pzhandle_t; newFn: watcher_fn): watcher_fn; cdecl;
(* *
  * \brief returns the socket address for the current connection
  * \return socket address of the connected host or NULL on failure, only valid if the
  * connection is current connected
*)

function zookeeper_get_connected_host(zh: pzhandle_t; var addr: psockaddr; var addr_len: socklen_t): psockaddr; cdecl;

(* *
  * \brief signature of a completion function for a call that returns void.
  *
  * This method will be invoked at the end of a asynchronous call and also as
  * a result of connection loss or timeout.
  * \param rc the error code of the call. Connection loss/timeout triggers
  * the completion with one of the following error codes:
  * ZCONNECTIONLOSS -- lost connection to the server
  * ZOPERATIONTIMEOUT -- connection timed out
  * Data related events trigger the completion with error codes listed the
  * Exceptions section of the documentation of the function that initiated the
  * call. (Zero indicates call was successful.)
  * \param data the pointer that was passed by the caller when the function
  *   that this completion corresponds to was invoked. The programmer
  *   is responsible for any memory freeing associated with the data
  *   pointer.
*)
type
  void_completion_t = procedure(rc: Integer; data: Pointer); cdecl;

  (* *
    * \brief signature of a completion function that returns a TStat structure.
    *
    * This method will be invoked at the end of a asynchronous call and also as
    * a result of connection loss or timeout.
    * \param rc the error code of the call. Connection loss/timeout triggers
    * the completion with one of the following error codes:
    * ZCONNECTIONLOSS -- lost connection to the server
    * ZOPERATIONTIMEOUT -- connection timed out
    * Data related events trigger the completion with error codes listed the
    * Exceptions section of the documentation of the function that initiated the
    * call. (Zero indicates call was successful.)
    * \param stat a pointer to the stat information for the node involved in
    *   this function. If a non zero error code is returned, the content of
    *   stat is undefined. The programmer is NOT responsible for freeing stat.
    * \param data the pointer that was passed by the caller when the function
    *   that this completion corresponds to was invoked. The programmer
    *   is responsible for any memory freeing associated with the data
    *   pointer.
  *)
type
  stat_completion_t = procedure(rc: Integer; TStat: pStat; data: Pointer); cdecl;

  (* *
    * \brief signature of a completion function that returns data.
    *
    * This method will be invoked at the end of a asynchronous call and also as
    * a result of connection loss or timeout.
    * \param rc the error code of the call. Connection loss/timeout triggers
    * the completion with one of the following error codes:
    * ZCONNECTIONLOSS -- lost connection to the server
    * ZOPERATIONTIMEOUT -- connection timed out
    * Data related events trigger the completion with error codes listed the
    * Exceptions section of the documentation of the function that initiated the
    * call. (Zero indicates call was successful.)
    * \param value the value of the information returned by the asynchronous call.
    *   If a non zero error code is returned, the content of value is undefined.
    *   The programmer is NOT responsible for freeing value.
    * \param value_len the number of bytes in value.
    * \param stat a pointer to the stat information for the node involved in
    *   this function. If a non zero error code is returned, the content of
    *   stat is undefined. The programmer is NOT responsible for freeing stat.
    * \param data the pointer that was passed by the caller when the function
    *   that this completion corresponds to was invoked. The programmer
    *   is responsible for any memory freeing associated with the data
    *   pointer.
  *)
type
  data_completion_t = procedure(rc: Integer; value: PAnsiChar; value_len: Integer; TStat: pStat; data: Pointer); cdecl;

  (* *
    * \brief signature of a completion function that returns a list of strings.
    *
    * This method will be invoked at the end of a asynchronous call and also as
    * a result of connection loss or timeout.
    * \param rc the error code of the call. Connection loss/timeout triggers
    * the completion with one of the following error codes:
    * ZCONNECTIONLOSS -- lost connection to the server
    * ZOPERATIONTIMEOUT -- connection timed out
    * Data related events trigger the completion with error codes listed the
    * Exceptions section of the documentation of the function that initiated the
    * call. (Zero indicates call was successful.)
    * \param strings a pointer to the structure containng the list of strings of the
    *   names of the children of a node. If a non zero error code is returned,
    *   the content of strings is undefined. The programmer is NOT responsible
    *   for freeing strings.
    * \param data the pointer that was passed by the caller when the function
    *   that this completion corresponds to was invoked. The programmer
    *   is responsible for any memory freeing associated with the data
    *   pointer.
  *)
type
  strings_completion_t = procedure(rc: Integer; strings: pString_vector; data: Pointer); cdecl;

  (* *
    * \brief signature of a completion function that returns a list of strings and stat.
    * .
    *
    * This method will be invoked at the end of a asynchronous call and also as
    * a result of connection loss or timeout.
    * \param rc the error code of the call. Connection loss/timeout triggers
    * the completion with one of the following error codes:
    * ZCONNECTIONLOSS -- lost connection to the server
    * ZOPERATIONTIMEOUT -- connection timed out
    * Data related events trigger the completion with error codes listed the
    * Exceptions section of the documentation of the function that initiated the
    * call. (Zero indicates call was successful.)
    * \param strings a pointer to the structure containng the list of strings of the
    *   names of the children of a node. If a non zero error code is returned,
    *   the content of strings is undefined. The programmer is NOT responsible
    *   for freeing strings.
    * \param stat a pointer to the stat information for the node involved in
    *   this function. If a non zero error code is returned, the content of
    *   stat is undefined. The programmer is NOT responsible for freeing stat.
    * \param data the pointer that was passed by the caller when the function
    *   that this completion corresponds to was invoked. The programmer
    *   is responsible for any memory freeing associated with the data
    *   pointer.
  *)
type
  strings_stat_completion_t = procedure(rc: Integer; strings: pString_vector; TStat: pStat; data: Pointer); cdecl;

  (* *
    * \brief signature of a completion function that returns a list of strings.
    *
    * This method will be invoked at the end of a asynchronous call and also as
    * a result of connection loss or timeout.
    * \param rc the error code of the call. Connection loss/timeout triggers
    * the completion with one of the following error codes:
    * ZCONNECTIONLOSS -- lost connection to the server
    * ZOPERATIONTIMEOUT -- connection timed out
    * Data related events trigger the completion with error codes listed the
    * Exceptions section of the documentation of the function that initiated the
    * call. (Zero indicates call was successful.)
    * \param value the value of the string returned.
    * \param data the pointer that was passed by the caller when the function
    *   that this completion corresponds to was invoked. The programmer
    *   is responsible for any memory freeing associated with the data
    *   pointer.
  *)
type
  string_completion_t = procedure(rc: Integer; value: PAnsiChar; data: Pointer); cdecl;

  (* *
    * \brief signature of a completion function that returns an ACL.
    *
    * This method will be invoked at the end of a asynchronous call and also as
    * a result of connection loss or timeout.
    * \param rc the error code of the call. Connection loss/timeout triggers
    * the completion with one of the following error codes:
    * ZCONNECTIONLOSS -- lost connection to the server
    * ZOPERATIONTIMEOUT -- connection timed out
    * Data related events trigger the completion with error codes listed the
    * Exceptions section of the documentation of the function that initiated the
    * call. (Zero indicates call was successful.)
    * \param acl a pointer to the structure containng the ACL of a node. If a non
    *   zero error code is returned, the content of strings is undefined. The
    *   programmer is NOT responsible for freeing acl.
    * \param stat a pointer to the stat information for the node involved in
    *   this function. If a non zero error code is returned, the content of
    *   stat is undefined. The programmer is NOT responsible for freeing stat.
    * \param data the pointer that was passed by the caller when the function
    *   that this completion corresponds to was invoked. The programmer
    *   is responsible for any memory freeing associated with the data
    *   pointer.
  *)
type
  acl_completion_t = procedure(rc: Integer; acl: pACL_vector; TStat: pStat; data: Pointer); cdecl;
  (* *
    * \brief get the state of the zookeeper connection.
    *
    * The return value will be one of the \ref State Consts.
  *)

function zoo_state(zh: pzhandle_t): Integer; cdecl;
(* *
  * \brief create a node.
  *
  * This method will create a node in ZooKeeper. A node can only be created if
  * it does not already exists. The Create Flags affect the creation of nodes.
  * If ZOO_EPHEMERAL flag is set, the node will automatically get removed if the
  * client session goes away. If the ZOO_SEQUENCE flag is set, a unique
  * monotonically increasing sequence number is appended to the path name. The
  * sequence number is always fixed length of 10 digits, 0 padded.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path The name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param value The data to be stored in the node.
  * \param valuelen The number of bytes in data.
  * \param acl The initial ACL of the node. The ACL must not be null or empty.
  * \param flags this parameter can be set to 0 for normal create or an OR
  *    of the Create Flags
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the parent node does not exist.
  * ZNODEEXISTS the node already exists
  * ZNOAUTH the client does not have permission.
  * ZNOCHILDRENFOREPHEMERALS cannot create children of ephemeral nodes.
  * \param data The data that will be passed to the completion routine when the
  * function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_acreate(zh: pzhandle_t; path: PAnsiChar; value: PAnsiChar; valuelen: Integer; acl: pACL_vector; flags: Integer; completion: string_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief delete a node in zookeeper.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param version the expected version of the node. The function will fail if the
  *    actual version of the node does not match the expected version.
  *  If -1 is used the version check will not take place.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADVERSION expected version does not match actual version.
  * ZNOTEMPTY children are present; node cannot be deleted.
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_adelete(zh: pzhandle_t; path: PAnsiChar; version: Integer; completion: void_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief checks the existence of a node in zookeeper.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watch if nonzero, a watch will be set at the server to notify the
  * client if the node changes. The watch will be set even if the node does not
  * exist. This allows clients to watch for nodes to appear.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * \param data the data that will be passed to the completion routine when the
  * function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_aexists(zh: pzhandle_t; path: PAnsiChar; watch: Integer; completion: stat_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief checks the existence of a node in zookeeper.
  *
  * This function is similar to \ref zoo_axists except it allows one specify
  * a watcher object - a function pointer and associated context. The function
  * will be called once the watch has fired. The associated context data will be
  * passed to the function as the watcher context parameter.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watcher if non-null a watch will set on the specified znode on the server.
  * The watch will be set even if the node does not exist. This allows clients
  * to watch for nodes to appear.
  * \param watcherCtx user specific data, will be passed to the watcher callback.
  * Unlike the global context set by \ref zookeeper_init, this watcher context
  * is associated with the given instance of the watcher only.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * \param data the data that will be passed to the completion routine when the
  * function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_awexists(zh: pzhandle_t; path: PAnsiChar; watcher: watcher_fn; watcherCtx: Pointer; completion: stat_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief gets the data associated with a node.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watch if nonzero, a watch will be set at the server to notify
  * the client if the node changes.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either in ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_aget(zh: pzhandle_t; path: PAnsiChar; watch: Integer; completion: data_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief gets the data associated with a node.
  *
  * This function is similar to \ref zoo_aget except it allows one specify
  * a watcher object rather than a boolean watch flag.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watcher if non-null, a watch will be set at the server to notify
  * the client if the node changes.
  * \param watcherCtx user specific data, will be passed to the watcher callback.
  * Unlike the global context set by \ref zookeeper_init, this watcher context
  * is associated with the given instance of the watcher only.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either in ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_awget(zh: pzhandle_t; path: PAnsiChar; watcher: watcher_fn; watcherCtx: Pointer; completion: data_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief sets the data associated with a node.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param buffer the buffer holding data to be written to the node.
  * \param buflen the number of bytes from buffer to write.
  * \param version the expected version of the node. The function will fail if
  * the actual version of the node does not match the expected version. If -1 is
  * used the version check will not take place. * completion: If null,
  * the function will execute synchronously. Otherwise, the function will return
  * immediately and invoke the completion routine when the request completes.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADVERSION expected version does not match actual version.
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_aset(zh: pzhandle_t; path: PAnsiChar; buffer: PAnsiChar; buflen: Integer; version: Integer; completion: stat_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief lists the children of a node.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watch if nonzero, a watch will be set at the server to notify
  * the client if the node changes.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_aget_children(zh: pzhandle_t; path: PAnsiChar; watch: Integer; completion: strings_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief lists the children of a node.
  *
  * This function is similar to \ref zoo_aget_children except it allows one specify
  * a watcher object rather than a boolean watch flag.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watcher if non-null, a watch will be set at the server to notify
  * the client if the node changes.
  * \param watcherCtx user specific data, will be passed to the watcher callback.
  * Unlike the global context set by \ref zookeeper_init, this watcher context
  * is associated with the given instance of the watcher only.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_awget_children(zh: pzhandle_t; path: PAnsiChar; watcher: watcher_fn; watcherCtx: Pointer; completion: strings_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief lists the children of a node, and get the parent stat.
  *
  * This function is new in version 3.3.0
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watch if nonzero, a watch will be set at the server to notify
  * the client if the node changes.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_aget_children2(zh: pzhandle_t; path: PAnsiChar; watch: Integer; completion: strings_stat_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief lists the children of a node, and get the parent stat.
  *
  * This function is similar to \ref zoo_aget_children2 except it allows one specify
  * a watcher object rather than a boolean watch flag.
  *
  * This function is new in version 3.3.0
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watcher if non-null, a watch will be set at the server to notify
  * the client if the node changes.
  * \param watcherCtx user specific data, will be passed to the watcher callback.
  * Unlike the global context set by \ref zookeeper_init, this watcher context
  * is associated with the given instance of the watcher only.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_awget_children2(zh: pzhandle_t; path: PAnsiChar; watcher: watcher_fn; watcherCtx: Pointer; completion: strings_stat_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief Flush leader channel.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_async(zh: pzhandle_t; path: PAnsiChar; completion: string_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief gets the acl associated with a node.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_aget_acl(zh: pzhandle_t; path: PAnsiChar; completion: acl_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief sets the acl associated with a node.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param buffer the buffer holding the acls to be written to the node.
  * \param buflen the number of bytes from buffer to write.
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with one of the following codes passed in as the rc argument:
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZINVALIDACL invalid ACL specified
  * ZBADVERSION expected version does not match actual version.
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_aset_acl(zh: pzhandle_t; path: PAnsiChar; version: Integer; acl: pACL_vector; completion: void_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief atomically commits multiple zookeeper operations.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param count the number of operations
  * \param ops an array of operations to commit
  * \param results an array to hold the results of the operations
  * \param completion the routine to invoke when the request completes. The completion
  * will be triggered with any of the error codes that can that can be returned by the
  * ops supported by a multi op (see \ref zoo_acreate, \ref zoo_adelete, \ref zoo_aset).
  * \param data the data that will be passed to the completion routine when
  * the function completes.
  * \return the return code for the function call. This can be any of the
  * values that can be returned by the ops supported by a multi op (see
  * \ref zoo_acreate, \ref zoo_adelete, \ref zoo_aset).
*)

function zoo_amulti(zh: pzhandle_t; count: Integer; ops: pzoo_op_t; results: pzoo_op_result_t; completion: void_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief return an error string.
  *
  * \param return code
  * \return string corresponding to the return code
*)

function zerror(c: Integer): PAnsiChar; cdecl;
(* *
  * \brief specify application credentials.
  *
  * The application calls this function to specify its credentials for purposes
  * of authentication. The server will use the security provider specified by
  * the scheme parameter to authenticate the client connection. If the
  * authentication request has failed:
  * - the server connection is dropped
  * - the watcher is called with the ZOO_AUTH_FAILED_STATE value as the state
  * parameter.
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param scheme the id of authentication scheme. Natively supported:
  * 'digest' password-based authentication
  * \param cert application credentials. The actual value depends on the scheme.
  * \param certLen the length of the data parameter
  * \param completion the routine to invoke when the request completes. One of
  * the following result codes may be passed into the completion callback:
  * ZOK operation completed successfully
  * ZAUTHFAILED authentication failed
  * \param data the data that will be passed to the completion routine when the
  * function completes.
  * \return ZOK on success or one of the following errcodes on failure:
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
  * ZSYSTEMERROR - a system error occured
*)

function zoo_add_auth(zh: pzhandle_t; scheme: PAnsiChar; cert: PAnsiChar; certLen: Integer; completion: void_completion_t; data: Pointer): Integer; cdecl;
(* *
  * \brief checks if the current zookeeper connection state can't be recovered.
  *
  *  The application must close the zhandle and try to reconnect.
  *
  * \param zh the zookeeper handle (see \ref zookeeper_init)
  * \return ZINVALIDSTATE if connection is unrecoverable
*)

function is_unrecoverable(zh: pzhandle_t): Integer; cdecl;
(* *
  * \brief sets the debugging level for the library
*)

procedure zoo_set_debug_level(logLevel: ZooLogLevel); cdecl;
(* *
  * \brief sets the stream to be used by the library for logging
  *
  * The zookeeper library uses stderr as its default log stream. Application
  * must make sure the stream is writable. Passing in NULL resets the stream
  * to its default value (stderr).
*)

// procedure zoo_set_log_stream(logStream: FILE); cdecl;
(* *
  * \brief enable/disable quorum endpoint order randomization
  *
  * Note: typically this method should NOT be used outside of testing.
  *
  * If passed a non-zero value, will make the client connect to quorum peers
  * in the order as specified in the zookeeper_init() call.
  * A zero value causes zookeeper_init() to permute the peer endpoints
  * which is good for more even client connection distribution among the
  * quorum peers.
*)

procedure zoo_deterministic_conn_order(yesOrNo: Integer); cdecl;
(* *
  * \brief create a node synchronously.
  *
  * This method will create a node in ZooKeeper. A node can only be created if
  * it does not already exists. The Create Flags affect the creation of nodes.
  * If ZOO_EPHEMERAL flag is set, the node will automatically get removed if the
  * client session goes away. If the ZOO_SEQUENCE flag is set, a unique
  * monotonically increasing sequence number is appended to the path name.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path The name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param value The data to be stored in the node.
  * \param valuelen The number of bytes in data. To set the data to be NULL use
  * value as NULL and valuelen as -1.
  * \param acl The initial ACL of the node. The ACL must not be null or empty.
  * \param flags this parameter can be set to 0 for normal create or an OR
  *    of the Create Flags
  * \param path_buffer Buffer which will be filled with the path of the
  *    new node (this might be different than the supplied path
  *    because of the ZOO_SEQUENCE flag).  The path string will always be
  *    null-terminated. This parameter may be NULL if path_buffer_len = 0.
  * \param path_buffer_len Size of path buffer; if the path of the new
  *    node (including space for the null terminator) exceeds the buffer size,
  *    the path string will be truncated to fit.  The actual path of the
  *    new node in the server will not be affected by the truncation.
  *    The path string will always be null-terminated.
  * \return  one of the following codes are returned:
  * ZOK operation completed successfully
  * ZNONODE the parent node does not exist.
  * ZNODEEXISTS the node already exists
  * ZNOAUTH the client does not have permission.
  * ZNOCHILDRENFOREPHEMERALS cannot create children of ephemeral nodes.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_create(zh: pzhandle_t; path: PAnsiChar; value: PAnsiChar; valuelen: Integer; acl: pACL_vector; flags: Integer; path_buffer: PAnsiChar; path_buffer_len: Integer): Integer; cdecl;
(* *
  * \brief delete a node in zookeeper synchronously.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param version the expected version of the node. The function will fail if the
  *    actual version of the node does not match the expected version.
  *  If -1 is used the version check will not take place.
  * \return one of the following values is returned.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADVERSION expected version does not match actual version.
  * ZNOTEMPTY children are present; node cannot be deleted.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_delete(zh: pzhandle_t; path: PAnsiChar; version: Integer): Integer; cdecl;
(* *
  * \brief checks the existence of a node in zookeeper synchronously.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watch if nonzero, a watch will be set at the server to notify the
  * client if the node changes. The watch will be set even if the node does not
  * exist. This allows clients to watch for nodes to appear.
  * \param the return stat value of the node.
  * \return  return code of the function call.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_exists(zh: pzhandle_t; path: PAnsiChar; watch: Integer; TStat: pStat): Integer; cdecl;
(* *
  * \brief checks the existence of a node in zookeeper synchronously.
  *
  * This function is similar to \ref zoo_exists except it allows one specify
  * a watcher object rather than a boolean watch flag.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watcher if non-null a watch will set on the specified znode on the server.
  * The watch will be set even if the node does not exist. This allows clients
  * to watch for nodes to appear.
  * \param watcherCtx user specific data, will be passed to the watcher callback.
  * Unlike the global context set by \ref zookeeper_init, this watcher context
  * is associated with the given instance of the watcher only.
  * \param the return stat value of the node.
  * \return  return code of the function call.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_wexists(zh: pzhandle_t; path: PAnsiChar; watcher: watcher_fn; watcherCtx: Pointer; TStat: pStat): Integer; cdecl;
(* *
  * \brief gets the data associated with a node synchronously.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watch if nonzero, a watch will be set at the server to notify
  * the client if the node changes.
  * \param buffer the buffer holding the node data returned by the server
  * \param buffer_len is the size of the buffer pointed to by the buffer parameter.
  * It'll be set to the actual data length upon return. If the data is NULL, length is -1.
  * \param stat if not NULL, will hold the value of stat for the path on return.
  * \return return value of the function call.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either in ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_get(zh: pzhandle_t; path: PAnsiChar; watch: Integer; buffer: PAnsiChar; buffer_len: Pointer; TStat: pStat): Integer; cdecl;
(* *
  * \brief gets the data associated with a node synchronously.
  *
  * This function is similar to \ref zoo_get except it allows one specify
  * a watcher object rather than a boolean watch flag.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watcher if non-null, a watch will be set at the server to notify
  * the client if the node changes.
  * \param watcherCtx user specific data, will be passed to the watcher callback.
  * Unlike the global context set by \ref zookeeper_init, this watcher context
  * is associated with the given instance of the watcher only.
  * \param buffer the buffer holding the node data returned by the server
  * \param buffer_len is the size of the buffer pointed to by the buffer parameter.
  * It'll be set to the actual data length upon return. If the data is NULL, length is -1.
  * \param stat if not NULL, will hold the value of stat for the path on return.
  * \return return value of the function call.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either in ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_wget(zh: pzhandle_t; path: PAnsiChar; watcher: watcher_fn; watcherCtx: Pointer; buffer: PAnsiChar; buffer_len: Pointer; TStat: pStat): Integer; cdecl;
(* *
  * \brief sets the data associated with a node. See zoo_set2 function if
  * you require access to the stat information associated with the znode.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param buffer the buffer holding data to be written to the node.
  * \param buflen the number of bytes from buffer to write. To set NULL as data
  * use buffer as NULL and buflen as -1.
  * \param version the expected version of the node. The function will fail if
  * the actual version of the node does not match the expected version. If -1 is
  * used the version check will not take place.
  * \return the return code for the function call.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADVERSION expected version does not match actual version.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_set(zh: pzhandle_t; path: PAnsiChar; buffer: PAnsiChar; buflen: Integer; version: Integer): Integer; cdecl;
(* *
  * \brief sets the data associated with a node. This function is the same
  * as zoo_set except that it also provides access to stat information
  * associated with the znode.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param buffer the buffer holding data to be written to the node.
  * \param buflen the number of bytes from buffer to write. To set NULL as data
  * use buffer as NULL and buflen as -1.
  * \param version the expected version of the node. The function will fail if
  * the actual version of the node does not match the expected version. If -1 is
  * used the version check will not take place.
  * \param stat if not NULL, will hold the value of stat for the path on return.
  * \return the return code for the function call.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADVERSION expected version does not match actual version.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_set2(zh: pzhandle_t; path: PAnsiChar; buffer: PAnsiChar; buflen: Integer; version: Integer; TStat: pStat): Integer; cdecl;
(* *
  * \brief lists the children of a node synchronously.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watch if nonzero, a watch will be set at the server to notify
  * the client if the node changes.
  * \param strings return value of children paths.
  * \return the return code of the function.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_get_children(zh: pzhandle_t; path: PAnsiChar; watch: Integer; strings: pString_vector): Integer; cdecl;
(* *
  * \brief lists the children of a node synchronously.
  *
  * This function is similar to \ref zoo_get_children except it allows one specify
  * a watcher object rather than a boolean watch flag.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watcher if non-null, a watch will be set at the server to notify
  * the client if the node changes.
  * \param watcherCtx user specific data, will be passed to the watcher callback.
  * Unlike the global context set by \ref zookeeper_init, this watcher context
  * is associated with the given instance of the watcher only.
  * \param strings return value of children paths.
  * \return the return code of the function.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_wget_children(zh: pzhandle_t; path: PAnsiChar; watcher: watcher_fn; watcherCtx: Pointer; strings: pString_vector): Integer; cdecl;
(* *
  * \brief lists the children of a node and get its stat synchronously.
  *
  * This function is new in version 3.3.0
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watch if nonzero, a watch will be set at the server to notify
  * the client if the node changes.
  * \param strings return value of children paths.
  * \param stat return value of node stat.
  * \return the return code of the function.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_get_children2(zh: pzhandle_t; path: PAnsiChar; watch: Integer; strings: pString_vector; TStat: pStat): Integer; cdecl;
(* *
  * \brief lists the children of a node and get its stat synchronously.
  *
  * This function is similar to \ref zoo_get_children except it allows one specify
  * a watcher object rather than a boolean watch flag.
  *
  * This function is new in version 3.3.0
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param watcher if non-null, a watch will be set at the server to notify
  * the client if the node changes.
  * \param watcherCtx user specific data, will be passed to the watcher callback.
  * Unlike the global context set by \ref zookeeper_init, this watcher context
  * is associated with the given instance of the watcher only.
  * \param strings return value of children paths.
  * \param stat return value of node stat.
  * \return the return code of the function.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_wget_children2(zh: pzhandle_t; path: PAnsiChar; watcher: watcher_fn; watcherCtx: Pointer; strings: pString_vector; TStat: pStat): Integer; cdecl;
(* *
  * \brief gets the acl associated with a node synchronously.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param acl the return value of acls on the path.
  * \param stat returns the stat of the path specified.
  * \return the return code for the function call.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_get_acl(zh: pzhandle_t; path: PAnsiChar; acl: pACL_vector; TStat: pStat): Integer; cdecl;
(* *
  * \brief sets the acl associated with a node synchronously.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param path the name of the node. Expressed as a file name with slashes
  * separating ancestors of the node.
  * \param version the expected version of the path.
  * \param acl the acl to be set on the path.
  * \return the return code for the function call.
  * ZOK operation completed successfully
  * ZNONODE the node does not exist.
  * ZNOAUTH the client does not have permission.
  * ZINVALIDACL invalid ACL specified
  * ZBADVERSION expected version does not match actual version.
  * ZBADARGUMENTS - invalid input parameters
  * ZINVALIDSTATE - zhandle state is either ZOO_SESSION_EXPIRED_STATE or ZOO_AUTH_FAILED_STATE
  * ZMARSHALLINGERROR - failed to marshall a request; possibly, out of memory
*)

function zoo_set_acl(zh: pzhandle_t; path: PAnsiChar; version: Integer; acl: pACL_vector): Integer; cdecl;
(* *
  * \brief atomically commits multiple zookeeper operations synchronously.
  *
  * \param zh the zookeeper handle obtained by a call to \ref zookeeper_init
  * \param count the number of operations
  * \param ops an array of operations to commit
  * \param results an array to hold the results of the operations
  * \return the return code for the function call. This can be any of the
  * values that can be returned by the ops supported by a multi op (see
  * \ref zoo_acreate, \ref zoo_adelete, \ref zoo_aset).
*)

function zoo_multi(zh: pzhandle_t; count: Integer; ops: pzoo_op_t; results: pzoo_op_result_t): Integer; cdecl;
{$ENDREGION}

(* *
  * This structure represents a packet being read or written.
*)
type
  p_buffer_list = ^_buffer_list;

  _buffer_list = record
    buffer: PAnsiChar;
    len: Integer; (* This represents the length of sizeof(header) + length of buffer *)
    curr_offset: Integer; (* This is the offset into the header followed by offset into the buffer *)
    next: p_buffer_list;
  end;

  buffer_list_t = _buffer_list;
  pbuffer_list_t = ^buffer_list_t;

{$REGION 'zk_adaptor.h'}

type

  // buffer_list_t = _buffer_list;
  // pbuffer_list_t = ^_buffer_list;

  // _completion_list = record
  // end;

  // completion_list_t = _completion_list;
  // pcompletion_list_t = ^completion_list_t;
  pcompletion_list_t = Pointer;

  _buffer_head = record [volatile]
    head: pbuffer_list_t;
    last: pbuffer_list_t;
    lock: pthread_mutex_t;
  end;

  buffer_head_t = _buffer_head;
  pbuffer_head_t = ^buffer_head_t;

  _completion_head = record [volatile]
    head: pcompletion_list_t;
    last: pcompletion_list_t;
    cond: pthread_cond_t;
    lock: pthread_mutex_t;
  end;

  completion_head_t = _completion_head;
  pcompletion_head_t = ^completion_head_t;

//function lock_buffer_list(l: pbuffer_head_t): Integer; cdecl;
//function unlock_buffer_list(l: pbuffer_head_t): Integer; cdecl;
//function lock_completion_list(l: pcompletion_head_t): Integer; cdecl;
//function unlock_completion_list(l: pcompletion_head_t): Integer; cdecl;

type
  sync_completion = record
    rc: Integer;

    u: record
      case Integer of
        0:
          (str: record str: PAnsiChar;
            str_len: Integer;
          end);
        1:
          (stat: TStat);
        2:
          (data: record buffer: PAnsiChar;
            buff_len: Integer;
            stat: TStat;
          end);
        3:
          (acl: record acl: ACL_vector;
            stat: TStat;
          end);
        4:
          (strs2: String_vector);
        5:
          (strs_stat: record strs2: String_vector;
            stat2: TStat;
          end);
    end;
  end;

  p_auth_info = ^_auth_info;

  _auth_info = record
    state: Integer; (* 0=>inactive, >0 => active *)
    scheme: PAnsiChar;
    auth: buffer;
    completion: void_completion_t;
    data: PAnsiChar;
    next: p_auth_info;
  end;

  auth_info = _auth_info;
  pauth_info = ^auth_info;

  // (* *
  // * This structure represents a packet being read or written.
  // *)
  // p_buffer_list=^_buffer_list;
  // _buffer_list = record
  // buffer: PAnsiChar;
  // len: integer; (* This represents the length of sizeof(header) + length of buffer *)
  // curr_offset: integer; (* This is the offset into the header followed by offset into the buffer *)
  // next: p_buffer_list;
  // end;
  //
  // buffer_list_t = _buffer_list;
  // pbuffer_list_t = ^buffer_list_t;

  (* the size of connect request *)
const
  HANDSHAKE_REQ_SIZE = 44;

  (* connect request *)
type
  connect_req = record
    protocolVersion: Int32;
    lastZxidSeen: Int64;
    timeOut: Int32;
    sessionId: Int64;
    passwd_len: Int32;
    passwd: array [0 .. Pred(16)] of AnsiChar;
  end;
  (* the connect response *)

  prime_struct = record
    len: Int32;
    protocolVersion: Int32;
    timeOut: Int32;
    sessionId: Int64;
    passwd_len: Int32;
    passwd: array [0 .. Pred(16)] of AnsiChar;
  end;
  (* this is used by mt_adaptor internally for thread management *)

  adaptor_threads = record
    io: pthread_t;
    completion: pthread_t;
    threadsToWait: Integer; (* barrier *)
    cond: pthread_cond_t; (* barrier's conditional *)
    lock: pthread_mutex_t; (* ... and a lock *)
    zh_lock: pthread_mutex_t; (* critical section lock *)
{$IF defined(WIN32) || defined(WIN64)}
    self_pipe: array [0 .. Pred(2)] of SOCKET;
{$ELSE}
    self_pipe: array [0 .. Pred(2)] of Integer;
{$ENDIF}
  end;

  padaptor_threads = ^adaptor_threads;

  (* * the auth list for adding auth *)
  _auth_list_head = record
    auth: pauth_info;
    lock: pthread_mutex_t;
  end;

  auth_list_head_t = _auth_list_head;
  pauth_list_head_t = ^auth_list_head_t;

  (* *
    * This structure represents the connection to zookeeper.
  *)

  _zhandle = record
{$IF defined(WIN32) || defined(WIN64)}
    fd: SOCKET; (* the descriptor used to talk to zookeeper *)
{$ELSE}
    fd: Integer; (* the descriptor used to talk to zookeeper *)
{$ENDIF}
    hostname: PAnsiChar; (* the hostname of zookeeper *)
    addrs: PSockAddrStorage; (* the addresses that correspond to the hostname *)
    addrs_count: Integer; (* The number of addresses in the addrs array *)
    watcher: watcher_fn; (* the registered watcher *)
    last_recv: timeval; (* The time that the last message was received *)
    last_send: timeval; (* The time that the last message was sent *)
    last_ping: timeval; (* The time that the last PING was sent *)
    next_deadline: timeval; (* The time of the next deadline *)
    recv_timeout: Integer; (* The maximum amount of time that can go by without
      receiving anything from the zookeeper server *)
    input_buffer: pbuffer_list_t; (* the current buffer being read in *)
    to_process: buffer_head_t; (* The buffers that have been read and are ready to be processed. *)
    to_send: buffer_head_t; (* The packets queued to send *)
    sent_requests: completion_head_t; (* The outstanding requests *)
    completions_to_process: completion_head_t; (* completions that are ready to run *)
    connect_index: Integer; (* The index of the address to connect to *)
    client_id: clientid_t;
    last_zxid: Integer;
    outstanding_sync: Integer; (* Number of outstanding synchronous requests *)
    primer_buffer: _buffer_list; (* The buffer used for the handshake at the start of a connection *)
    primer_storage: prime_struct; (* the connect response *)
    primer_storage_buffer: array [0 .. Pred(40)] of AnsiChar; (* the true size of primer_storage *)
    [volatile]
    state: Integer;
    context: pinteger;
    auth_h: auth_list_head_t; (* authentication data list *)
    (* zookeeper_close is not reentrant because it de-allocates the zhandler.
      * This guard variable is used to defer the destruction of zhandle till
      * right before top-level API call returns to the caller *)
    ref_counter: Int32;
    [volatile]
    close_requested: Integer;
    adaptor_priv: pinteger; (* Used for debugging only: non-zero value indicates the time when the zookeeper_process
      * call returned while there was at least one unprocessed server response
      * available in the socket recv buffer *)
    socket_readable: timeval;
    active_node_watchers: pzk_hashtable;
    active_exist_watchers: pzk_hashtable;
    active_child_watchers: pzk_hashtable; (* * used for chroot path at the client side * *)
    chroot: PAnsiChar;
  end;

//function adaptor_init(zh: pzhandle_t): Integer; cdecl;
//procedure adaptor_finish(zh: pzhandle_t); cdecl;
//procedure adaptor_destroy(zh: pzhandle_t); cdecl;
//function alloc_sync_completion: psync_completion; cdecl;
//function wait_sync_completion(sc: psync_completion): Integer; cdecl;
//procedure free_sync_completion(sc: psync_completion); cdecl;
//procedure notify_sync_completion(sc: psync_completion); cdecl;
//function adaptor_send_queue(zh: pzhandle_t; timeOut: Integer): Integer; cdecl;
//function process_async(outstanding_sync: Integer): Integer; cdecl;
//procedure process_completions(zh: pzhandle_t); cdecl;
//function flush_send_queue(zh: pzhandle_t; timeOut: Integer): Integer; cdecl;
//function sub_string(zh: pzhandle_t; server_path: PAnsiChar): PAnsiChar; cdecl;
//procedure free_duplicate_path(free_path: PAnsiChar; path: PAnsiChar); cdecl;
//function zoo_lock_auth(zh: pzhandle_t): Integer; cdecl;
//function zoo_unlock_auth(zh: pzhandle_t): Integer; cdecl;
//(* critical section guards *)
//function enter_critical(zh: pzhandle_t): Integer; cdecl;
//function leave_critical(zh: pzhandle_t): Integer; cdecl;
//(* zhandle object reference counting *)
//procedure api_prolog(zh: pzhandle_t); cdecl;
//function api_epilog(zh: pzhandle_t; rc: Integer): Integer; cdecl;
//function get_xid: Int32; cdecl;
//(* returns the new value of the ref counter *)
//function inc_ref_counter(zh: pzhandle_t; i: Integer): Int32; cdecl;
//(* atomic post-increment *)
//function fetch_and_add([volatile] operand: Int32; incr: Integer): Int32; cdecl;
//(* in mt mode process session event asynchronously by the completion thread *)

{$ENDREGION}

implementation

procedure zoo_create_op_init;external LIBFILE;

procedure zoo_delete_op_init;external LIBFILE;

procedure zoo_set_op_init;external LIBFILE;

procedure zoo_check_op_init;external LIBFILE;

function zookeeper_init;external LIBFILE;

function zookeeper_close;external LIBFILE;

function zoo_client_id;external LIBFILE;

function zoo_recv_timeout;external LIBFILE;

function zoo_get_context;external LIBFILE;

procedure zoo_set_context;external LIBFILE;

function zoo_set_watcher;external LIBFILE;

function zookeeper_get_connected_host;external LIBFILE;

function zoo_state;external LIBFILE;

function zoo_acreate;external LIBFILE;

function zoo_adelete;external LIBFILE;

function zoo_aexists;external LIBFILE;

function zoo_awexists;external LIBFILE;

function zoo_aget;external LIBFILE;

function zoo_awget;external LIBFILE;

function zoo_aset;external LIBFILE;

function zoo_aget_children;external LIBFILE;

function zoo_awget_children;external LIBFILE;

function zoo_aget_children2;external LIBFILE;

function zoo_awget_children2;external LIBFILE;

function zoo_async;external LIBFILE;

function zoo_aget_acl;external LIBFILE;

function zoo_aset_acl;external LIBFILE;

function zoo_amulti;external LIBFILE;

function zerror;external LIBFILE;

function zoo_add_auth;external LIBFILE;

function is_unrecoverable;external LIBFILE;

procedure zoo_set_debug_level;external LIBFILE;

// procedure zoo_set_log_stream;external LIBFILE;

procedure zoo_deterministic_conn_order;external LIBFILE;

function zoo_create;external LIBFILE;

function zoo_delete;external LIBFILE;

function zoo_exists;external LIBFILE;

function zoo_wexists;external LIBFILE;

function zoo_get;external LIBFILE;

function zoo_wget;external LIBFILE;

function zoo_set;external LIBFILE;

function zoo_set2;external LIBFILE;

function zoo_get_children;external LIBFILE;

function zoo_wget_children;external LIBFILE;

function zoo_get_children2;external LIBFILE;

function zoo_wget_children2;external LIBFILE;

function zoo_get_acl;external LIBFILE;

function zoo_set_acl;external LIBFILE;

function zoo_multi;external LIBFILE;

end.
