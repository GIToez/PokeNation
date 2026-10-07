////////////////////////////////////////////////////////////////////////
// OpenTibia - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////

#ifndef __POLLS__
#define __POLLS__

#include <map>
#include <string>
#include <stdint.h>

class Poll;

typedef std::map<uint32_t, Poll*> PollsMap;
typedef std::map<uint32_t, std::string> PollOptionsMap;

class Poll
{
	public:
		Poll(uint32_t id, std::string name, std::string question, uint64_t deadline, PollOptionsMap pollOptions, bool textMode);		
		virtual ~Poll();
		
		uint32_t getId();
        std::string getName();
		std::string getQuestion();
		uint64_t getDeadline();
		bool getTextMode();
		PollOptionsMap* getPollOptions();

	private:
        uint32_t m_id;
        std::string m_name;
        std::string m_question;
        uint64_t m_deadline;
        PollOptionsMap m_pollOptions;
        bool m_textMode;

};

class Polls
{
    public:
		virtual ~Polls();
		static Polls* getInstance()
		{
			static Polls instance;
			return &instance;
		}
		
		void load();
		bool registerPoll(uint32_t pollId, std::string pollName, std::string pollQuestion,
                uint64_t deadline, bool textMode, PollOptionsMap pollOptions);
		
		Poll* getAvailablePollForAccount(uint32_t accountNumber);
		bool doComputePollVote(uint32_t accountNumber, uint8_t pollVote);
		bool doComputePollVote(uint32_t accountNumber, std::string text);
		void checkPolls();

	private:
		PollsMap pollsMap;

		Polls();
		
		void clear();
};

#endif
