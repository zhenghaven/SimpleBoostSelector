// Copyright (c) 2022 Haofan Zheng
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

#include <memory>
#include <string>
#include <thread>

#include <gtest/gtest.h>

#include <boost/asio.hpp>

namespace SimpleBoost_Test
{
	extern size_t g_numOfTestFile;
}

GTEST_TEST(Networking, CountTestFile)
{
	static auto tmp = ++SimpleBoost_Test::g_numOfTestFile;
	(void)tmp;
}

class TestingTCPServer : public ::testing::Test
{
public:
	TestingTCPServer() :
		m_ipAddr(static_cast<uint32_t>(
			boost::asio::ip::address_v4::from_string("127.0.0.1").to_uint())),
		m_serverIO(),
		m_serverAcc(m_serverIO,
			boost::asio::ip::tcp::endpoint(
					boost::asio::ip::address_v4(m_ipAddr),
					0)),
		m_portNum(static_cast<uint16_t>(m_serverAcc.local_endpoint().port())),
		m_thread(),
		m_msg()
	{
	}

	virtual void SetUp() override
	{
		m_thread.reset(new std::thread([&]()
			{
				std::string msgBuf;
				msgBuf.resize(1024);

				auto socket = m_serverAcc.accept();
				socket.set_option(boost::asio::ip::tcp::no_delay(true));
				socket.receive(boost::asio::buffer(&msgBuf[0], msgBuf.size()));

				m_msg = msgBuf.c_str();
			}));
	}

	virtual void TearDown() override
	{
	}

	virtual ~TestingTCPServer()
	{
	}

	void WaitServerToFinish()
	{
		if(m_thread)
		{
			m_thread->join();
		}
	}

	uint32_t m_ipAddr;
	boost::asio::io_service m_serverIO;
	boost::asio::basic_socket_acceptor<
		boost::asio::ip::tcp,
		boost::asio::executor> m_serverAcc;
	uint16_t m_portNum;

	std::unique_ptr<std::thread> m_thread;

	std::string m_msg;
};

TEST_F(TestingTCPServer, ServerReceivingMsg)
{
	boost::asio::io_service cltServerIo;
	boost::asio::ip::tcp::socket cltSocket(cltServerIo);

	cltSocket.connect(
		boost::asio::ip::tcp::endpoint(
			boost::asio::ip::address_v4(m_ipAddr),
			m_portNum));
	cltSocket.set_option(boost::asio::ip::tcp::no_delay(true));

	std::string testMsg = "TCP connection testing message";
	cltSocket.send(boost::asio::buffer(testMsg.data(), testMsg.size()));

	WaitServerToFinish();

	EXPECT_EQ(testMsg, m_msg);
}
