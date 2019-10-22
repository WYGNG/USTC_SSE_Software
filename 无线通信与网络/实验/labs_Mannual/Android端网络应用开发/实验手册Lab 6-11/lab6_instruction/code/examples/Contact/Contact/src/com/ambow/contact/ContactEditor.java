package com.ambow.contact;

import com.ambow.contact.R;
import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;

public class ContactEditor extends Activity {
	
	private static final String TAG = "ContactEditor";
		
	private static final int STATE_EDIT = 0;
    private static final int STATE_INSERT = 1;
    
    private static final int REVERT_ID = Menu.FIRST;
    private static final int DELETE_ID = Menu.FIRST + 1;
    private static final int DISCARD_ID = Menu.FIRST + 2;
    
	private int mState;
    private Uri mUri;
    private Cursor mCursor;
    
    private EditText companyText;
    private EditText nameText;
    private EditText phoneText;
    private EditText emailText;
    private Button saveButton;
    private Button cancelButton;
    
    private String originalCompanyText = "";
    private String originalNameText = "";
    private String originalPhoneText = "";
    private String originalEmailText = "";

	public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        final Intent intent = getIntent();
        final String action = intent.getAction();
        Log.d(TAG+":onCreate", action);
        
        if (Intent.ACTION_EDIT.equals(action)) {
            mState = STATE_EDIT;
            mUri = intent.getData();
        } else if (Intent.ACTION_INSERT.equals(action)) {
            mState = STATE_INSERT;
            mUri = getContentResolver().insert(intent.getData(), null);

            if (mUri == null) {
                Log.e(TAG+":onCreate", "Failed to insert new Contact into " + getIntent().getData());
                finish();
                return;
            }
            setResult(RESULT_OK, new Intent().setAction(mUri.toString()));

        } else {
            Log.e(TAG+":onCreate", " unknown action");
            finish();
            return;
        }
        
        setContentView(R.layout.contact_editor);
        
        companyText = (EditText) findViewById(R.id.EditText06);
        nameText = (EditText) findViewById(R.id.EditText01);
        phoneText = (EditText) findViewById(R.id.EditText02);
        emailText = (EditText) findViewById(R.id.EditText03);
        saveButton = (Button)findViewById(R.id.Button01);
        cancelButton = (Button)findViewById(R.id.Button02);
        
        saveButton.setOnClickListener(new OnClickListener(){

			public void onClick(View v) {
				String text = nameText.getText().toString();
				if(text.length()==0){	
					deleteContact();
					setResult(RESULT_CANCELED);
					finish();
				}else{
					updateContact();
				}
			}
        });
        
        cancelButton.setOnClickListener(new OnClickListener(){

			public void onClick(View v) {
				if(mState == STATE_INSERT){
					deleteContact();
					setResult(RESULT_CANCELED);
					finish();
				}else{
					backupContact();
				}       
			}
        	
        });
        
        Log.d(TAG+":onCreate", mUri.toString());

        mCursor = managedQuery(mUri, ContactColumn.PROJECTION, null, null, null);
        mCursor.moveToFirst();
        
        originalCompanyText = mCursor.getString(4);
        originalNameText = mCursor.getString(ContactColumn.NAME_COLUMN);
        originalPhoneText = mCursor.getString(ContactColumn.MOBILE_COLUMN);
        originalEmailText = mCursor.getString(ContactColumn.EMAIL_COLUMN);
        
        companyText.setText(originalCompanyText);
        nameText.setText(originalNameText);
        phoneText.setText(originalPhoneText);
        emailText.setText(originalEmailText);
        
        if (mState == STATE_EDIT) {
            setTitle("����ͨѶ¼ - " + getText(R.string.contact_edit));
        } else if (mState == STATE_INSERT) {
            setTitle("����ͨѶ¼ - " + getText(R.string.contact_create));
        }
   
    }
	
	@Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        
        if (mState == STATE_EDIT) {
            menu.add(0, REVERT_ID, 0, R.string.menu_revert)
                    .setIcon(android.R.drawable.ic_menu_revert);
            menu.add(0, DELETE_ID, 0, R.string.menu_delete)
            .setIcon(android.R.drawable.ic_menu_delete);
        }else{
            menu.add(0, DISCARD_ID, 0, R.string.menu_discard)
                    .setIcon(android.R.drawable.ic_menu_revert);
        }
        return true;
    }
	@Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
        case DELETE_ID:
        	deleteContact();
            finish();
        	break;
        case DISCARD_ID:
        	cancelContact();
            break;
        case REVERT_ID:
        	backupContact();
            break;
        }
        return super.onOptionsItemSelected(item);
    }

	private void deleteContact() {
		if (mCursor != null) {
            mCursor.close();
            getContentResolver().delete(mUri, null, null);
        }
	}
	
	private void cancelContact() {
		deleteContact();
        setResult(RESULT_CANCELED);
        finish();
	}

	private void updateContact() {
		if (mCursor != null) {
			mCursor.close();
            ContentValues values = new ContentValues();
            values.put(ContactColumn.COMPANY, companyText.getText().toString());
            values.put(ContactColumn.NAME, nameText.getText().toString());
            values.put(ContactColumn.MOBILE, phoneText.getText().toString());
            values.put(ContactColumn.EMAIL, emailText.getText().toString());
            getContentResolver().update(mUri, values, null, null);
        }
        setResult(RESULT_OK);
        finish();
	}

	private void backupContact() {
		if (mCursor != null) {
			mCursor.close();
            ContentValues values = new ContentValues();
            values.put(ContactColumn.COMPANY, originalCompanyText);
            values.put(ContactColumn.NAME, originalNameText);
            values.put(ContactColumn.MOBILE, originalPhoneText);
            values.put(ContactColumn.EMAIL, originalEmailText);
            getContentResolver().update(mUri, values, null, null);
        }
        setResult(RESULT_CANCELED);
        finish();	
	}
	
}
