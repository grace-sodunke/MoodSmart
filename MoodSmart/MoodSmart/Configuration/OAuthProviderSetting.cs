using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Auth;

namespace MoodSmart
{
    public class OAuthProviderSetting
    {
        //public string ClientId { get; private set; }  Only needed for Oauth 1
        public string ConsumerKey { get; private set; }
        public string ConsumerSecret { get; private set; }
        public string RequestTokenUrl { get; private set; }
        public string AccessTokenUrl { get; private set; }
        public string AuthorizeUrl { get; private set; }
        public string CallbackUrl { get; private set; }

        public enum OauthIdentityProvider
        {
            TWITTER           
        }

        public OAuth1Authenticator LoginWithTwitter()
        {
            OAuth1Authenticator Twitterauth = null;
            try
            {
                Twitterauth = new OAuth1Authenticator(
                           consumerKey: "3SLRgE1fCsFbCN3HDVl73Vdz3",    
                           consumerSecret: "WixsILg05cUWYBBOeOP7vxPPBuUwcdyX3N9pqtMQ3z1xoQIx1B",  
                           requestTokenUrl: new Uri("https://api.twitter.com/oauth/request_token"), 
                           authorizeUrl: new Uri("https://api.twitter.com/oauth/authorize"), 
                           accessTokenUrl: new Uri("https://api.twitter.com/oauth/access_token"), 
                           callbackUrl: new Uri("http://mobile.twitter.com/home")  //https://moodsmart-e2625.firebaseapp.com/__/auth/handler
                       );
            }
            catch (Exception ex)
            {

            }
            return Twitterauth;
        }
    }
}
