using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Firebase;
using Firebase.Database;

namespace MoodSmart.Droid.Helpers
{
    public static class AppDataHelper
    {
        public static FirebaseDatabase GetDatabase()
        {
            var app = FirebaseApp.InitializeApp(Application.Context);
            FirebaseDatabase database;

            if(app == null)
            {
                var option = new FirebaseOptions.Builder()
                    .SetApplicationId("moodsmart-e2625")
                    .SetApiKey("AIzaSyDiPedy1RYqlz7dOlvjXjOU10R4No3BCGg")
                    .SetDatabaseUrl("https://moodsmart-e2625.firebaseio.com")
                    .SetStorageBucket("moodsmart-e2625.appspot.com")
                    .Build();
                
                app = FirebaseApp.InitializeApp(Application.Context, option);
                database = FirebaseDatabase.GetInstance(app);
            }
            else
            {
                database = FirebaseDatabase.GetInstance(app);
            }

            return database;
        }
    }
}