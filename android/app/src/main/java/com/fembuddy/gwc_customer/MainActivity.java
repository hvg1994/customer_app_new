package com.fembuddy.gwc_customer;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.bandyer.android_sdk.call.CallObserver;
import com.bandyer.android_sdk.call.CallRecordingObserver;
import com.bandyer.android_sdk.call.CallUIObserver;

import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "callNative";
    private static final String CHANNEL1 = "callNative1";


    private MainPresenter mMainPresenter;

    MethodChannel methodChannel;

    EventChannel eventChannel;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));
        mMainPresenter = new MainPresenter(this);

        methodChannel = new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), CHANNEL);
        eventChannel=   new EventChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL1);


        methodChannel.setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                        if(call.method.equals("kaleyra_call")){
                            String userId = call.argument("user_id");
                            String joinUrl = call.argument("url");
                            String kaleyraAccessToken = call.argument("access_token");
                            mMainPresenter.joinMeeting(userId, joinUrl,kaleyraAccessToken, result);
                        }
                        else if(call.method.equals("call_support")){
                            String userId = call.argument("user_id");
                            String successKaleyraId = call.argument("success_id");
                            String kaleyraAccessToken = call.argument("access_token");
                            mMainPresenter.normalCall(userId, successKaleyraId,kaleyraAccessToken);
                        }
                    }
                }
        );

        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
//                HashMap hashMap = (HashMap) arguments;

                Log.d("args", String.valueOf(arguments));

                try{
                    if(arguments.equals("eventChannel")){

                        mMainPresenter.events = events;

                    /*for(int i=0;i<10;i++){
                        events.success("success"+ i);
                        Log.e("valll",String.valueOf(i));
                    }*/
                    }else{
                        events.error("err","err","err");

                    }
                }
                catch(Exception e){
                    events.error("err", e.getMessage(), e.getMessage());
                }

            }

            @Override
            public void onCancel(Object arguments) {

            }
        });


    }
}
