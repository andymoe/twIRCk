#import "GLGIRCParser.h"
#import "GLGIRCMessage.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(MessageParsingSpecSpec)

describe(@"MessageParsingSpec", ^{
    __block NSString *input;

    describe(@"#parseString", ^{
        describe(@"parsing command messages", ^{
            describe(@"joining channels", ^{
                it(@"should parse /join messages without an octothorpe", ^{
                    input = @"/join cheese_lovers";
                    GLGIRCMessage *message = [GLGIRCParser parseString:input];

                    [message type] should equal(@"join");
                    [message raw] should equal(@"JOIN #cheese_lovers");
                    [message message] should equal(@"/join #cheese_lovers");
                });

                it(@"should parse /join messages with an octothorpe", ^{
                    input = @"/join #cheese_haters";
                    GLGIRCMessage *message = [GLGIRCParser parseString:input];

                    [message type] should equal(@"join");
                    [message raw] should equal(@"JOIN #cheese_lovers");
                    [message message] should equal(@"/join #cheese_haters");
                });
            });

            it(@"should parse /part messages", ^{
                input = @"/part losers";
                GLGIRCMessage *message = [GLGIRCParser parseString:input];

                [message type] should equal(@"part");
                [message raw] should equal(@"PART #losers");
                [message message] should equal(@"/part #losers");
            });

            describe(@"parsing /msg private messages", ^{
                it(@"should parse private messages as /msg", ^{
                    input = @"/msg god hey man I got some good ideas for the new NEW testament";
                    GLGIRCMessage *msg = [GLGIRCParser parseString:input];

                    [msg type] should equal(@"msg");
                    [msg raw] should equal(@"PRIVMSG god :hey man I got some good ideas for the new NEW testament");
                    [msg message] should equal(@"<%nick%> hey man I got some good ideas for the new NEW testament");
                });

                it(@"should parse private messages with /whisper", ^{
                    input = @"/whisper devil WTS soul. LF primordial saronite";
                    GLGIRCMessage *msg = [GLGIRCParser parseString:input];

                    [msg type] should equal(@"msg");
                    [msg raw] should equal(@"PRIVMSG devil :WTS soul. LF primordial saronite");
                    [msg message] should equal(@"<%nick%> WTS soul. LF primordial saronite");
                });
            });

            it(@"should parse /who messages", ^{
                input = @"/who batman";
                GLGIRCMessage *msg = [GLGIRCParser parseString:input];

                [msg type] should equal(@"who");
                [msg raw] should equal(@"WHO batman");
                [msg message] should equal(@"/who batman");
            });

            xit(@"should parse /me messages", ^{
                // TODO needs to be able to support binary in strings
                NO should equal(YES);
            });

            it(@"should parse /nick messages", ^{
                input = @"/nick bruceWayne";
                GLGIRCMessage *msg = [GLGIRCParser parseString:input];

                [msg type] should equal(@"nick");
                [msg raw] should equal(@"NICK bruceWayne");
                [msg message] should equal(@"/nick bruceWayne");
            });

            it(@"should parse /pass messages", ^{
                input = @"/pass ILoveMyDeadGaySon";
                GLGIRCMessage *msg = [GLGIRCParser parseString:input];

                [msg type] should equal(@"pass");
                [msg raw] should equal(@"PASS ILoveMyDeadGaySon");
                [msg message] should equal(@"/pass ILoveMyDeadGaySon");
            });
            
            it(@"should parse /topic messages", ^{
                input = @"/topic a new version of twIRCk.app is available! Please update now and report any bugs";
                GLGIRCMessage *msg = [GLGIRCParser parseString:input];

                [msg type] should equal(@"topic");
                [msg raw] should equal(@"TOPIC %channel% a new version of twIRCk.app is available! Please update now and report any bugs");
                [msg message] should equal(@"/topic a new version of twIRCk.app is available! Please update now and report any bugs");
            });
            
            it(@"should treat other /cmd messages as having no target", ^{
                input = @"/foo bar baz buz";
                GLGIRCMessage *msg = [GLGIRCParser parseString:input];

                [msg type] should equal(@"foo");
                [msg raw] should equal(@"FOO bar baz buz");
                [msg message] should equal(@"/foo bar baz buz");
            });
        });

        it(@"should treat all other messages as a message in the current channel", ^{
            input = @"Good morning Vietnam!";
            GLGIRCMessage *msg = [GLGIRCParser parseString:input];

            [msg type] should equal(@"msg");
            [msg raw] should equal(@"PRIVMSG %channel% :Good Morning Vietnam!");
            [msg message] should equal(@"<%nick%> Good Morning Vietnam!");
        });
    });
});

SPEC_END
