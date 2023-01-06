package com.fembuddy.gwc_customer;

import static android.content.ContentValues.TAG;

import static com.kaleyra.app_utilities.MultiDexApplication.getRestApi;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.bandyer.android_sdk.call.CallException;
import com.bandyer.android_sdk.call.CallModule;
import com.bandyer.android_sdk.call.CallObserver;
import com.bandyer.android_sdk.call.CallRecordingObserver;
import com.bandyer.android_sdk.call.CallUIObserver;
import com.bandyer.android_sdk.call.model.CallInfo;
import com.bandyer.android_sdk.call.notification.CallNotificationListener;
import com.bandyer.android_sdk.call.notification.CallNotificationStyle;
import com.bandyer.android_sdk.call.notification.CallNotificationType;
import com.bandyer.android_sdk.client.AccessTokenProvider;
import com.bandyer.android_sdk.client.BandyerSDK;
import com.bandyer.android_sdk.client.BandyerSDKConfiguration;
import com.bandyer.android_sdk.client.Session;
import com.bandyer.android_sdk.client.SessionObserver;
import com.bandyer.android_sdk.intent.BandyerIntent;
import com.bandyer.android_sdk.intent.call.Call;
import com.bandyer.android_sdk.intent.call.CallRecordingState;
import com.bandyer.android_sdk.intent.call.IncomingCall;
import com.bandyer.android_sdk.module.BandyerModule;
import com.bandyer.android_sdk.module.BandyerModuleObserver;
import com.bandyer.android_sdk.module.BandyerModuleStatus;
import com.bandyer.android_sdk.tool_configuration.call.SimpleCallConfiguration;
import com.kaleyra.app_configuration.activities.ConfigurationActivity;
import com.kaleyra.app_configuration.model.Configuration;
import com.kaleyra.app_utilities.storage.ConfigurationPrefsManager;
import com.kaleyra.app_utilities.storage.LoginManager;
import com.kaleyra.collaboration_suite_networking.Environment;
import com.kaleyra.collaboration_suite_networking.Region;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MainPresenter extends AppCompatActivity implements BandyerModuleObserver {

    protected Activity mContext;

    EventChannel.EventSink events;


    String apiKey = "ak_live_c1ef0ed161003e0a2b419d20";
    String appId = "mAppId_002b0de9c8982a72afd4524b1b539313a7f044871c2e6225d691015cb8d9";

    Environment environment = Environment.Sandbox.INSTANCE; // or Environment.Sandbox.INSTANCE

    Region region = Region.Eu.INSTANCE;

    String resultValue = "";
    HashMap resultMap = new HashMap();

    public MainPresenter(Context context){
        super();
        mContext = (Activity) context;

    }

    abstract class MyCallObserver implements CallUIObserver, CallObserver, CallRecordingObserver {
    }

    @Override
    public void onModuleFailed(@NonNull BandyerModule bandyerModule, @NonNull Throwable throwable) {

    }

    @Override
    public void onModulePaused(@NonNull BandyerModule bandyerModule) {

    }

    @Override
    public void onModuleReady(@NonNull BandyerModule bandyerModule) {

    }

    @Override
    public void onModuleStatusChanged(@NonNull BandyerModule bandyerModule, @NonNull BandyerModuleStatus bandyerModuleStatus) {

    }

    private void sdkConfig(String userId, String accessToken){
        BandyerSDKConfiguration.Builder builder1 = new BandyerSDKConfiguration.Builder(
                appId,
                environment,
                region);

        builder1.tools(builder -> {
            builder.withCall(configurableCall -> {
                // this callback will be called to optionally
                // set and update the call configuration
                configurableCall.setCallConfiguration(new SimpleCallConfiguration());
            });
        }).notificationListeners(builder -> {
            builder.setCallNotificationListener(getCallNotificationListener());
        }).build();


        BandyerSDK.getInstance().configure(builder1.build());

//        if (!LoginManager.isUserLogged(mContext)){
//            LoginManager.login(mContext, userId);
//        }
        startBandyerSDK(userId, accessToken);

    }
    private void startBandyerSDK(String userId, String accessToken) {
        Log.d("loggedUser", userId);
        Configuration configuration = ConfigurationPrefsManager.INSTANCE.getConfiguration(mContext);

        new ConfigurationActivity().updateConfiguration(apiKey, appId, environment.getName(), region.getName(), configuration);

//        AccessTokenProvider accessTokenProvider = (userId1, completion) -> getRestApi().getAccessTokenNew(userId, apiKey, environment.getName(), region.getName(), accessToken -> {
//            completion.success(accessToken);
//            Log.d("token:", accessToken);
//            return null;
//        }, exception -> {
//            Log.e("error:", exception.getMessage());
//            completion.error(exception);
//            return null;
//        });
        AccessTokenProvider accessTokenProvider = (userId1, completion) ->
//                completion.success("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiMyIsImNvbXBhbnlJZCI6ImNhZDAzMzFmLWU0N2QtNDZjYS1hM2U3LTc1NjBiMzVmMGJjZCIsImFsbG93Q2FtZXJhIjp0cnVlLCJpYXQiOjE2NzE1Mjk3MzQsImV4cCI6MTY3MTUzMzMzNCwiaXNzIjoiQHN3aXRjaGJvYXJkLWNvcmUiLCJzdWIiOiIzI2NhZDAzMzFmLWU0N2QtNDZjYS1hM2U3LTc1NjBiMzVmMGJjZCJ9.H-Qpq_pLZS4YMcLjZvDjU4TI-PdKAdFIFMXd8LRcuAQ");

                completion.success(accessToken);
        SessionObserver sessionObserver = new SessionObserver() {

            @Override
            public void onSessionAuthenticating(@NonNull Session session) {
                Log.d(TAG, "onSessionAuthenticating for user " + session.getUserId());
            }

            @Override
            public void onSessionAuthenticated(@NonNull Session session) {
                Log.d(TAG, "onSessionAuthenticated for user " + session.getUserId());
            }

            @Override
            public void onSessionRefreshing(@NonNull Session session) {
                Log.d(TAG, "onSessionRefreshing for user " + session.getUserId());
            }

            @Override
            public void onSessionRefreshed(@NonNull Session session) {
                Log.d(TAG, "onSessionRefreshed for user " + session.getUserId());
            }

            @Override
            public void onSessionError(@NonNull Session session, @NonNull Error error) {
                Log.e(TAG, "onSessionError for user " + session.getUserId() + " with error: " + error.getMessage());
            }
        };

        Session session = new Session(
                userId,
                accessTokenProvider,
                sessionObserver
        );

        BandyerSDK.getInstance().connect(
                session,
                errorReason -> Log.e(TAG, "Unable to connect BandyerSDK with error: " + errorReason)
        );

//        BandyerSDK.getInstance().handleNotification();
    }


    public void joinMeeting(String userId, String JoinUrl,String accessToken, MethodChannel.Result result){
        sdkConfig(userId, accessToken);
//        Uri uri = Uri.parse("https://sandbox.bandyer.com/eu/direct-rest-call-handler/54e99cced226c5bec7787245be");

        addObservers();
        Uri uri = Uri.parse(JoinUrl);

        if (uri == null) return;

//        // do not handle the url if we do not have a valid user
//        if (!LoginManager.isUserLogged(mContext)){
//            LoginManager.login(mContext, userId);
//        }

//                BandyerIntent bandyerIntent = new BandyerIntent.Builder().startWithAudioCall(getApplicationContext())
//                        .with(new ArrayList<>(Arrays.asList("2")))
//                        .build();

        BandyerIntent bandyerIntent = new BandyerIntent.Builder()
                .startFromJoinCallUrl(mContext, uri.toString())
                .build();

        mContext.startActivity(bandyerIntent);

    }

    public void normalCall(String userId, String successTeamId,String accessToken){
        sdkConfig(userId, accessToken);
//        Uri uri = Uri.parse("https://sandbox.bandyer.com/eu/direct-rest-call-handler/54e99cced226c5bec7787245be");

        addObservers();

        ArrayList<String> l = new ArrayList<>();
        l.add(successTeamId);
        BandyerIntent bandyerIntent = new BandyerIntent.Builder()
                .startWithAudioCall(mContext)
                .with(l)
                .build();

        mContext.startActivity(bandyerIntent);
    }

    private boolean areObserversAdded = false;

    private void addObservers() {
        if (areObserversAdded) return;
        areObserversAdded = true;

        // Add an observer for the chat and call modules
        BandyerSDK.getInstance().addModuleObserver(this);

        // set an observer for the call to show ongoing call label
        CallModule callModule = BandyerSDK.getInstance().getCallModule();
        callModule.addCallObserver(this, callObserver);
//        if (callModule.isInCall()) showOngoingCallLabel();
//        else hideOngoingCallLabel();

        // set an observer for the ongoing chat
//        ChatModule chatModule = BandyerSDK.getInstance().getChatModule();
//        chatModule.addChatObserver(this, chatObserver);
//        chatModule.addChatUIObserver(this, chatObserver);
    }

    private final MainPresenter.MyCallObserver callObserver = new MainPresenter.MyCallObserver() {

        @Override
        public void onActivityError(@NonNull Call ongoingCall, @NonNull WeakReference<AppCompatActivity> callActivity, @NonNull CallException error) {
            android.util.Log.e(TAG, "onCallActivityError " + error.getMessage());
            Call callModuleOngoingCall = BandyerSDK.getInstance().getCallModule().getOngoingCall();
            if (callModuleOngoingCall != null && ongoingCall != callModuleOngoingCall) return;
        }

        @Override
        public void onActivityDestroyed(@NonNull Call ongoingCall, @NonNull WeakReference<AppCompatActivity> callActivity) {
            android.util.Log.d(TAG, "onCallActivityDestroyed");
            Call callModuleOngoingCall = BandyerSDK.getInstance().getCallModule().getOngoingCall();
            if (callModuleOngoingCall != null && ongoingCall != callModuleOngoingCall) return;
        }

        @Override
        public void onActivityStarted(@NonNull Call ongoingCall, @NonNull WeakReference<AppCompatActivity> callActivity) {
            android.util.Log.d(TAG, "onCallActivityStarted");
        }

        @Override
        public void onCallStarted(@NonNull Call ongoingCall) {
            android.util.Log.d(TAG, "onCallStarted");
            ongoingCall.addCallRecordingObserver(this);
        }

        @Override
        public void onCallCreated(@NonNull Call ongoingCall) {
            android.util.Log.d(TAG, "onCallCreated");
            resultMap = new HashMap<String, String>()
            {{
                    put("status", "onCallCreated");
                    put("data", String.valueOf(ongoingCall.getCallInfo()));
                }};
            Log.d("evenets:=>", events.toString());
            Log.d("resultMap", resultMap.toString());
            if(events != null)
                events.success(resultMap);

        }

        @Override
        public void onCallEnded(@NonNull Call ongoingCall) {
            android.util.Log.d(TAG, "onCallEnded");
            Call callModuleOngoingCall = BandyerSDK.getInstance().getCallModule().getOngoingCall();
            if (callModuleOngoingCall != null && ongoingCall != callModuleOngoingCall) return;
            ongoingCall.removeCallRecordingObserver(this);
            resultMap = new HashMap<String, String>()
            {{
                put("status", "onCallEnded");
                put("data", String.valueOf(ongoingCall.getCallInfo()));
            }};
            if(events != null)
                events.success(resultMap);
        }

        @Override
        public void onCallEndedWithError(@NonNull Call ongoingCall, @NonNull CallException callException) {
            android.util.Log.d(TAG, "onCallEnded with error: " + callException.getMessage());
            Call callModuleOngoingCall = BandyerSDK.getInstance().getCallModule().getOngoingCall();
            if (callModuleOngoingCall != null && ongoingCall != callModuleOngoingCall) return;
            ongoingCall.removeCallRecordingObserver(this);
            resultMap = new HashMap<String, String>()
            {{
                put("status", "onCallEndedWithError");
                put("error", callException.getMessage());
            }};
            if(events != null)
                events.success(resultMap);

        }

        @Override
        public void onCallRecordingStateChanged(@NonNull Call call, @NonNull CallRecordingState callRecordingState) {
            switch (callRecordingState) {
                case STOPPED:
//                    recordingSnackbar = KaleyraRecordingSnackbar.make(findViewById(R.id.main_view), KaleyraRecordingSnackbar.Type.TYPE_ENDED, Snackbar.LENGTH_LONG);
                    break;
                case STARTED:
//                    recordingSnackbar = KaleyraRecordingSnackbar.make(findViewById(R.id.main_view), KaleyraRecordingSnackbar.Type.TYPE_STARTED, Snackbar.LENGTH_LONG);
                    break;
            }
//            recordingSnackbar.show();
        }

        @Override
        public void onCallRecordingFailed(@NonNull Call call, @NonNull String reason) {
//            recordingSnackbar = KaleyraRecordingSnackbar.make(findViewById(R.id.main_view), KaleyraRecordingSnackbar.Type.TYPE_ERROR, Snackbar.LENGTH_LONG);
//            recordingSnackbar.show();
        }
    };


    public void removeObservers() {
        areObserversAdded = false;

        BandyerSDK.getInstance().removeModuleObserver(this);

        CallModule callModule = BandyerSDK.getInstance().getCallModule();
        if (callModule != null) {
            callModule.removeCallObserver(callObserver);
            callModule.removeCallUIObserver(callObserver);
            Call ongoingCall = callModule.getOngoingCall();
            if (ongoingCall != null) callModule.getOngoingCall().removeCallRecordingObserver(callObserver);
        }
    }

    private CallNotificationListener getCallNotificationListener() {
        // custom notification listener
        return new CallNotificationListener() {

            @Override
            public void onIncomingCall(@NonNull IncomingCall incomingCall, boolean isDnd, boolean isScreenLocked) {
                if (!isDnd || isScreenLocked)
                    incomingCall
                            .show(mContext);
                else {
                    incomingCall
                            .asNotification()
                            .show(mContext);
                }
            }

            @Override
            public void onCreateNotification(@NonNull CallInfo callInfo,
                                             @NonNull CallNotificationType type,
                                             @NonNull CallNotificationStyle notificationStyle) {
                notificationStyle.setNotificationColor(Color.RED);
            }


        };
    }



    @Override
    protected void onDestroy() {
        super.onDestroy();
        removeObservers();
        BandyerSDK.getInstance().disconnect();
    }
}
