//
//  cpp2swifttest.swift
//  cpp2swifttest
//
//  Created by pebble8888 on 2015/08/11.
//  Copyright (c) 2015年 pebble8888. All rights reserved.
//

import XCTest

class cpp2swifttest: XCTestCase {
    //var _parser = Parser()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /*
    func test1() {
        XCTAssertEqual(
            _parser.parse("static OSStatus  Open (const CAComponent& inComp, CAAudioUnit &outUnit);"),
            "static func Open(inComp:CAComponent&,\n&outUnit:CAAudioUnit) -> OSStatus\n")
    }
    
    func test2() {
        XCTAssertEqual(
            _parser.parse("OSStatus  GlobalReset ()\n" +
                "{\n" +
                "return AudioUnitReset (AU(), kAudioUnitScope_Global, 0);\n" +
                "}\n" ),
            "func GlobalReset() -> OSStatus\n{\nreturn AudioUnitReset (AU(), kAudioUnitScope_Global, 0);\n}\n"
        )
    }
    
    func test3() {
        XCTAssertEqual(
            _parser.parse("const \tCAComponent& \t Comp() const { return mComp; }"),
                "func Comp() -> CAComponent&\n{ return mComp; }\n" )
    }
    
    func test4() {
        XCTAssertEqual(
            _parser.parse( "void function1(void);"),
            "func function1()\n"
        )
    }
    
    func test41() {
        XCTAssertEqual(
            _parser.parse( "bool function1(bool flag);"),
            "func function1(flag:Bool) -> Bool\n"
        )
    }
    
    func test5() {
        XCTAssertEqual(
            _parser.parse(
            "void function1(void);\n" +
            "void function2(void){hoge;}\n" +
            "void function3(void){fuga;}\n" +
            "void function4(void);\n"),
            
            "func function1()\n" +
            "func function2()\n" +
            "{hoge;}\n" +
            "func function3()\n" +
            "{fuga;}\n" +
            "func function4()\n")
    }
    
    func test6() {
        XCTAssertEqual(
            _parser.parse("int function1()"),
            "func function1() -> Int\n")
    }
*/
    func test7() {
       
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        let str0 = "class    CAMutex\n" +
        "{\n" +
        "    // Construction/Destruction\n" +
        "    public:\n" +
        "    CAMutex(const char* inName);\n" +
        "    virtual        ~CAMutex();\n" +
        "\n" +
        "    // Actions\n" +
        "    public:\n" +
        "    virtual bool   Lock();\n" +
        "    virtual void   Unlock();\n" +
        "    virtual bool    Try(bool& outWasLocked);    // returns true if lock is free, false if not\n" +
        "\n" +
        "    virtual bool    IsFree() const;\n" +
        "    virtual bool    IsOwnedByCurrentThread() const;\n" +
        "\n" +
        "    // Implementation\n" +
        "    protected:\n" +
        "    const char*     mName;\n" +
        "    #if TARGET_OS_MAC\n" +
        "    pthread_t       mOwner;\n" +
        "    pthread_mutex_t    mMutex;\n" +
        "    #elif TARGET_OS_WIN32\n" +
        "    UInt32         mOwner;\n" +
        "    HANDLE         mMutex;\n" +
        "    #endif\n" +
        "\n" +
        "    // Helper class to manage taking and releasing recursively\n" +
        "    public:\n" +
        "    class      Locker\n" +
        "    {\n" +
        "\n" +
        "        // Construction/Destruction\n" +
        "        public:\n" +
        "        Locker(CAMutex& inMutex) : mMutex(&inMutex), mNeedsRelease(false) { mNeedsRelease = mMutex->Lock(); }\n" +
        "        Locker(CAMutex* inMutex) : mMutex(inMutex), mNeedsRelease(false) { mNeedsRelease = (mMutex != NULL && mMutex->Lock()); }\n" +
        "        // in this case the mutex can be null\n" +
        "        ~Locker() { if(mNeedsRelease) { mMutex->Unlock(); } }\n" +
        "\n" +
        "\n" +
        "        private:\n" +
        "        Locker(const Locker&);\n" +
        "        Locker&        operator=(const Locker&);\n" +
        "\n" +
        "        // Implementation\n" +
        "        private:\n" +
        "        CAMutex*   mMutex;\n" +
        "        bool       mNeedsRelease;\n" +
        "\n" +
        "    };\n" +
        "\n" +
        "    // Unlocker\n" +
        "    class Unlocker\n" +
        "    {\n" +
        "        public:\n" +
        "        Unlocker(CAMutex& inMutex);\n" +
        "        ~Unlocker();\n" +
        "\n" +
        "        private:\n" +
        "        CAMutex&   mMutex;\n" +
        "        bool       mNeedsLock;\n" +
        "\n" +
        "        // Hidden definitions of copy ctor, assignment operator\n" +
        "        Unlocker(const Unlocker& copy);            // Not implemented\n" +
        "        Unlocker& operator=(const Unlocker& copy); // Not implemented\n" +
        "    };\n" +
        "\n" +
        "    // you can use this with Try - if you take the lock in try, pass in the outWasLocked var\n" +
        "    class Tryer {\n" +
        "\n" +
        "        // Construction/Destruction\n" +
        "        public:\n" +
        "        Tryer (CAMutex &mutex) : mMutex(mutex), mNeedsRelease(false), mHasLock(false) { mHasLock = mMutex.Try (mNeedsRelease); }\n" +
        "        ~Tryer () { if (mNeedsRelease) mMutex.Unlock(); }\n" +
        "\n" +
        "        bool HasLock () const { return mHasLock; }\n" +
        "\n" +
        "        private:\n" +
        "        Tryer(const Tryer&);\n" +
        "        Tryer&     operator=(const Tryer&);\n" +
        "\n" +
        "        // Implementation\n" +
        "        private:\n" +
        "        CAMutex &      mMutex;\n" +
        "        bool           mNeedsRelease;\n" +
        "        bool           mHasLock;\n" +
        "    };\n" +
        "};\n"
        let t:Tokenizer = Tokenizer()
        t.parse(str0)
        //XCTAssertEqual(_parser.parse(str0), str1)
        let a:CPPAnalyzer = CPPAnalyzer()
        let gen:TokenGenerator = TokenGenerator(stack: t.stack)
        a.analyze(gen)
    }
}
