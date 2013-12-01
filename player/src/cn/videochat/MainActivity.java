package cn.videochat;

import cn.videochat.VideoChat.OnEventCallback;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.pm.ConfigurationInfo;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.EditText;

public class MainActivity extends Activity {
	VideoChat vc;
	Button btnListen, btnStop;
	EditText txtRTMPUrl;
	NativeView mView;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_main);
		txtRTMPUrl = (EditText) findViewById(R.id.editText1);

		if (IsSupportOpenGLSE2()) {
			// ��������
			vc = new VideoChat();
			vc.Init();
			vc.setOnEventCallback(new OnEventCallback() {
				@Override
				public void onEvent(int event) {
					// �¼��ص�(����)
				}
			});

			// ������Ƶ����
			mView = new NativeView(getApplication(), vc);
			this.addContentView(mView, new LayoutParams(LayoutParams.MATCH_PARENT, 480));

			// ����
			btnListen = (Button) findViewById(R.id.button1);
			btnListen.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					vc.OpenPlayer("http://183.203.16.207:8108/videochat/api/liveUrl?myid=admin&uid=" + txtRTMPUrl.getText().toString());
				}
			});

			// ֹͣ
			btnStop = (Button) findViewById(R.id.button2);
			btnStop.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					vc.ClosePlayer();
				}
			});
		} else {
	        Builder b = new AlertDialog.Builder(null);
	        b.setTitle(getString(R.string.app_name));
	        b.setMessage("����豸��֧��OpenGL���޷��ۿ���Ƶ��").show();		
		}
	}

	public boolean IsSupportOpenGLSE2() {
		ActivityManager activityManager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
		ConfigurationInfo configurationInfo = activityManager
				.getDeviceConfigurationInfo();

		return configurationInfo.reqGlEsVersion >= 0x20000;
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.activity_main, menu);
		return true;
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();

	}
}
