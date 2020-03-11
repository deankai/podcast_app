import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcastapp/bloc/player/player_bloc.dart';
import 'package:podcastapp/bloc/player/player_event.dart';
import 'package:podcastapp/bloc/player/player_state.dart';
import 'package:podcastapp/model/repository/vo/content_feed_item.dart';
import 'package:podcastapp/widget/customer_progress_indicator.dart';

class PlayerPage extends StatefulWidget {
  final String artworkUrl;
  final ContentFeedItem contentFeedItem;

  PlayerPage(
    this.artworkUrl,
    this.contentFeedItem,
  );

  @override
  State<StatefulWidget> createState() {
    return _PlayerPageState();
  }
}

class _PlayerPageState extends State<PlayerPage> {
  PlayerBloc bloc;

  Widget _buildImg(String artworkUrl) {
    return CachedNetworkImage(
      width: 250.0,
      height: 250.0,
      fit: BoxFit.fill,
      imageUrl: artworkUrl,
      placeholder: (context, url) {
        return Container(
          width: 250.0,
          height: 250.0,
          child: CustomerProgressIndicator(),
        );
      },
      errorWidget: (context, url, error) {
        return Icon(Icons.error);
      },
    );
  }

  Widget _buildSlider() {
    return Slider(
      value: 50,
      min: 0,
      max: 100,
      activeColor: Colors.white,
      inactiveColor: Colors.white30,
      onChanged: (double value) {
//        await flutterSound.seekToPlayer(value.toInt());
      },
      divisions: 100,
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Text(
        title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget _buildPlayer(PlayerState state, String contentUrl) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.replay_30, color: Colors.white70),
            iconSize: 50.0,
          ),
          state is Play || state is Resume
              ? IconButton(
                  icon: Icon(Icons.pause_circle_filled, color: Colors.white),
                  iconSize: 70.0,
                  onPressed: () {
                    bloc.add(PausePlayer());
                  },
                )
              : IconButton(
                  icon: Icon(Icons.play_circle_filled, color: Colors.white),
                  iconSize: 70.0,
                  onPressed: () {
                    bloc.add(ResumePlayer());
                  },
                ),
          IconButton(
            icon: Icon(Icons.forward_30, color: Colors.white70),
            iconSize: 50.0,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<PlayerBloc>(context);
    bloc.add(StartPlayer(widget.contentFeedItem.contentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is Loading) {
            return CustomerProgressIndicator();
          } else {
            return Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildImg(widget.artworkUrl),
                    SizedBox(height: 25.0),
                    _buildSlider(),
                    SizedBox(height: 20.0),
                    _buildTitle(widget.contentFeedItem.title),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildPlayer(state, widget.contentFeedItem.contentUrl),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
