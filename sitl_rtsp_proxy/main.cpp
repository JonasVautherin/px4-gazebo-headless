#include <gst/gst.h>
#include <gst/rtsp-server/rtsp-server.h>
#include <iostream>
#include <string>

int main(int argc, char* argv[]) {
    gst_init(&argc, &argv);

    GMainLoop* main_loop = g_main_loop_new(NULL, false);

    GstRTSPServer* server = gst_rtsp_server_new();
    g_object_set(server, "service", "8554", NULL);

    std::string launch_string = "udpsrc port=5600 caps=application/x-rtp,encoding-name=(string)H264 ! rtph264depay ! rtph264pay name=pay0";
    GstRTSPMediaFactory* factory = gst_rtsp_media_factory_new();
    gst_rtsp_media_factory_set_launch(factory, launch_string.c_str());
    gst_rtsp_media_factory_set_shared(factory, true);

    GstRTSPMountPoints* mount_points = gst_rtsp_server_get_mount_points(server);
    gst_rtsp_mount_points_add_factory(mount_points, "/live", factory);
    g_object_unref(mount_points);

    gst_rtsp_server_attach(server, NULL);

    g_main_loop_run(main_loop);
}
